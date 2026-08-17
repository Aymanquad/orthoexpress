import bcrypt from 'bcryptjs'
import { env } from '../config/env.js'
import { prisma } from '../lib/prisma.js'
import { normalizePhone } from '../lib/phone.js'

const OTP_TTL_MS = 10 * 60 * 1000
const MAX_VERIFY_ATTEMPTS = 5

function generateCode(): string {
  return String(Math.floor(100000 + Math.random() * 900000))
}

async function sendSms(phone: string, code: string) {
  if (env.OTP_DEV_MODE) {
    console.log(`[OTP DEV] ${phone} → ${code}`)
    return
  }

  const { TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_VERIFY_SERVICE_SID } = env
  if (!TWILIO_ACCOUNT_SID || !TWILIO_AUTH_TOKEN || !TWILIO_VERIFY_SERVICE_SID) {
    throw new Error('SMS provider is not configured')
  }

  const auth = Buffer.from(`${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}`).toString('base64')
  const body = new URLSearchParams({ To: phone, Channel: 'sms' })

  const res = await fetch(
    `https://verify.twilio.com/v2/Services/${TWILIO_VERIFY_SERVICE_SID}/Verifications`,
    {
      method: 'POST',
      headers: {
        Authorization: `Basic ${auth}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body,
    }
  )

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`Failed to send OTP: ${err}`)
  }
}

export async function requestOtp(rawPhone: string) {
  const phone = normalizePhone(rawPhone)
  const code = generateCode()
  const codeHash = await bcrypt.hash(code, 10)
  const expiresAt = new Date(Date.now() + OTP_TTL_MS)

  await prisma.otpChallenge.create({
    data: { phone, codeHash, expiresAt },
  })

  if (env.OTP_DEV_MODE) {
    console.log(`[OTP DEV] ${phone} → ${code}`)
  } else {
    await sendSms(phone, code)
  }

  return { phone, expiresAt }
}

export async function verifyOtp(rawPhone: string, code: string) {
  const phone = normalizePhone(rawPhone)

  const challenge = await prisma.otpChallenge.findFirst({
    where: { phone, consumedAt: null },
    orderBy: { createdAt: 'desc' },
  })

  if (!challenge) {
    throw new Error('No active verification code. Please request a new one.')
  }

  if (challenge.expiresAt < new Date()) {
    throw new Error('Verification code expired. Please request a new one.')
  }

  if (challenge.attempts >= MAX_VERIFY_ATTEMPTS) {
    throw new Error('Too many attempts. Please request a new code.')
  }

  const valid = await bcrypt.compare(code, challenge.codeHash)
  await prisma.otpChallenge.update({
    where: { id: challenge.id },
    data: { attempts: { increment: 1 } },
  })

  if (!valid) {
    throw new Error('Invalid verification code')
  }

  await prisma.otpChallenge.update({
    where: { id: challenge.id },
    data: { consumedAt: new Date() },
  })

  let patient = await prisma.patient.findUnique({ where: { phone } })
  if (!patient) {
    patient = await prisma.patient.create({ data: { phone } })
  }

  return patient
}

export async function countRecentOtpRequests(phone: string, windowMs: number) {
  const since = new Date(Date.now() - windowMs)
  return prisma.otpChallenge.count({
    where: { phone, createdAt: { gte: since } },
  })
}
