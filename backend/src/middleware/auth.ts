import type { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'
import { env } from '../config/env.js'
import { prisma } from '../lib/prisma.js'

export interface AuthPayload {
  patientId: string
  phone: string
}

declare global {
  namespace Express {
    interface Request {
      patient?: AuthPayload
    }
  }
}

export function signToken(payload: AuthPayload): string {
  return jwt.sign(payload, env.JWT_SECRET, {
    expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'],
  })
}

export function verifyToken(token: string): AuthPayload {
  return jwt.verify(token, env.JWT_SECRET) as AuthPayload
}

export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization
  const bearer = header?.startsWith('Bearer ') ? header.slice(7).trim() : ''
  const token = bearer || req.cookies?.[env.COOKIE_NAME]
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' })
  }

  try {
    const payload = verifyToken(token)
    const patient = await prisma.patient.findUnique({ where: { id: payload.patientId } })
    if (!patient || patient.phone !== payload.phone) {
      return res.status(401).json({ error: 'Invalid session' })
    }
    req.patient = payload
    next()
  } catch {
    return res.status(401).json({ error: 'Invalid or expired session' })
  }
}

export function setAuthCookie(res: Response, token: string) {
  res.cookie(env.COOKIE_NAME, token, {
    httpOnly: true,
    secure: env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 7 * 24 * 60 * 60 * 1000,
    path: '/',
  })
}

export function clearAuthCookie(res: Response) {
  res.clearCookie(env.COOKIE_NAME, { path: '/' })
}
