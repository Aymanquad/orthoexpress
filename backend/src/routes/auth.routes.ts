import { Router } from 'express'
import { z } from 'zod'
import { clearAuthCookie, requireAuth, setAuthCookie, signToken } from '../middleware/auth.js'
import { rateLimit } from '../middleware/rateLimit.js'
import { normalizePhone } from '../lib/phone.js'
import { countRecentOtpRequests, requestOtp, verifyOtp } from '../services/otp.service.js'
import { prisma } from '../lib/prisma.js'

const router = Router()

const phoneSchema = z.object({
  phone: z.string().min(7),
})

const verifySchema = z.object({
  phone: z.string().min(7),
  code: z.string().length(6).regex(/^\d+$/),
})

router.post(
  '/otp/request',
  rateLimit('otp-request', 10, 60 * 60 * 1000),
  async (req, res) => {
    try {
      const { phone } = phoneSchema.parse(req.body)
      const normalized = normalizePhone(phone)
      const recent = await countRecentOtpRequests(normalized, 60 * 60 * 1000)
      if (recent >= 3) {
        return res.status(429).json({ error: 'Too many code requests for this number. Try again later.' })
      }
      await requestOtp(phone)
      return res.json({ success: true, message: 'Verification code sent' })
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unable to send code'
      return res.status(400).json({ error: message })
    }
  }
)

router.post('/otp/verify', async (req, res) => {
  try {
    const { phone, code } = verifySchema.parse(req.body)
    const patient = await verifyOtp(phone, code)
    const token = signToken({ patientId: patient.id, phone: patient.phone })
    setAuthCookie(res, token)
    return res.json({
      token,
      patient: {
        id: patient.id,
        phone: patient.phone,
        firstName: patient.firstName,
        lastName: patient.lastName,
        email: patient.email,
      },
    })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Verification failed'
    return res.status(400).json({ error: message })
  }
})

router.post('/logout', (_req, res) => {
  clearAuthCookie(res)
  return res.json({ success: true })
})

router.get('/me', requireAuth, async (req, res) => {
  const patient = await prisma.patient.findUnique({
    where: { id: req.patient!.patientId },
    select: { id: true, phone: true, firstName: true, lastName: true, email: true },
  })
  if (!patient) return res.status(401).json({ error: 'Patient not found' })
  return res.json({ patient })
})

const profileSchema = z.object({
  firstName: z.string().trim().max(80).optional(),
  lastName: z.string().trim().max(80).optional(),
  email: z
    .string()
    .trim()
    .email()
    .max(120)
    .or(z.literal(''))
    .optional(),
  phone: z.string().min(7).optional(),
})

router.patch('/me', requireAuth, async (req, res) => {
  try {
    const body = profileSchema.parse(req.body ?? {})
    const patientId = req.patient!.patientId

    const data: {
      firstName?: string | null
      lastName?: string | null
      email?: string | null
      phone?: string
    } = {}

    if (body.firstName !== undefined) {
      data.firstName = body.firstName.length > 0 ? body.firstName : null
    }
    if (body.lastName !== undefined) {
      data.lastName = body.lastName.length > 0 ? body.lastName : null
    }
    if (body.email !== undefined) {
      data.email = body.email.length > 0 ? body.email : null
    }

    if (body.phone !== undefined) {
      const normalized = normalizePhone(body.phone)
      const existing = await prisma.patient.findUnique({ where: { phone: normalized } })
      if (existing && existing.id !== patientId) {
        return res.status(409).json({ error: 'That phone number is already in use.' })
      }
      data.phone = normalized
    }

    const patient = await prisma.patient.update({
      where: { id: patientId },
      data,
      select: { id: true, phone: true, firstName: true, lastName: true, email: true },
    })

    return res.json({ patient })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to update profile'
    return res.status(400).json({ error: message })
  }
})

export default router
