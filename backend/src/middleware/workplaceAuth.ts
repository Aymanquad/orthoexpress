import type { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'
import type { StaffRole } from '@prisma/client'
import { env } from '../config/env.js'
import { prisma } from '../lib/prisma.js'
import {
  FULL_PERMISSIONS,
  parsePermissions,
  type WorkplacePermissions,
} from '../lib/permissions.js'

export type WorkplaceAdminPayload = {
  typ: 'admin'
  adminId: string
}

export type WorkplaceStaffPayload = {
  typ: 'staff'
  staffId: string
  adminId: string
  role: StaffRole
}

export type WorkplacePayload = WorkplaceAdminPayload | WorkplaceStaffPayload

export type WorkplaceActor = {
  typ: 'admin' | 'staff'
  adminId: string
  staffId?: string
  email: string
  firstName: string | null
  lastName: string | null
  phone?: string | null
  role?: StaffRole
  permissions: WorkplacePermissions
  canManageStaff: boolean
}

declare global {
  namespace Express {
    interface Request {
      workplace?: WorkplaceActor
    }
  }
}

export function signWorkplaceToken(payload: WorkplacePayload): string {
  return jwt.sign(payload, env.JWT_SECRET, {
    expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'],
  })
}

export function verifyWorkplaceToken(token: string): WorkplacePayload {
  const decoded = jwt.verify(token, env.JWT_SECRET) as WorkplacePayload
  if (decoded.typ !== 'admin' && decoded.typ !== 'staff') {
    throw new Error('Invalid workplace token')
  }
  return decoded
}

export function setWorkplaceCookie(res: Response, token: string) {
  res.cookie(env.STAFF_COOKIE_NAME, token, {
    httpOnly: true,
    secure: env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 7 * 24 * 60 * 60 * 1000,
    path: '/',
  })
}

export function clearWorkplaceCookie(res: Response) {
  res.clearCookie(env.STAFF_COOKIE_NAME, { path: '/' })
}

async function resolveActor(payload: WorkplacePayload): Promise<WorkplaceActor | null> {
  if (payload.typ === 'admin') {
    const admin = await prisma.admin.findUnique({ where: { id: payload.adminId } })
    if (!admin || !admin.isActive) return null
    return {
      typ: 'admin',
      adminId: admin.id,
      email: admin.email,
      firstName: admin.firstName,
      lastName: admin.lastName,
      phone: admin.phone,
      permissions: FULL_PERMISSIONS,
      canManageStaff: true,
    }
  }

  const staff = await prisma.staff.findUnique({ where: { id: payload.staffId } })
  if (!staff || !staff.isActive) return null
  if (staff.adminId !== payload.adminId) return null
  return {
    typ: 'staff',
    adminId: staff.adminId,
    staffId: staff.id,
    email: staff.email,
    firstName: staff.firstName,
    lastName: staff.lastName,
    phone: staff.phone,
    role: staff.role,
    permissions: parsePermissions(staff.permissions),
    canManageStaff: false,
  }
}

export async function requireWorkplaceAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization
  const bearer = header?.startsWith('Bearer ') ? header.slice(7).trim() : ''
  const token = bearer || req.cookies?.[env.STAFF_COOKIE_NAME]
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' })
  }

  try {
    const payload = verifyWorkplaceToken(token)
    const actor = await resolveActor(payload)
    if (!actor) {
      return res.status(401).json({ error: 'Invalid session' })
    }
    req.workplace = actor
    next()
  } catch {
    return res.status(401).json({ error: 'Invalid or expired session' })
  }
}

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (!req.workplace || req.workplace.typ !== 'admin' || !req.workplace.canManageStaff) {
    return res.status(403).json({ error: 'Admin access required' })
  }
  next()
}

export function requirePermission(
  module: keyof WorkplacePermissions,
  access: 'read' | 'write'
) {
  return (req: Request, res: Response, next: NextFunction) => {
    const actor = req.workplace
    if (!actor) {
      return res.status(401).json({ error: 'Authentication required' })
    }
    if (actor.typ === 'admin') return next()
    const mod = actor.permissions[module]
    if (!mod || !mod[access]) {
      return res.status(403).json({ error: 'Insufficient permissions' })
    }
    next()
  }
}

export function requireAnyModule(
  modules: Array<keyof WorkplacePermissions>,
  access: 'read' | 'write'
) {
  return (req: Request, res: Response, next: NextFunction) => {
    const actor = req.workplace
    if (!actor) {
      return res.status(401).json({ error: 'Authentication required' })
    }
    if (actor.typ === 'admin') return next()
    const ok = modules.some((module) => Boolean(actor.permissions[module]?.[access]))
    if (!ok) {
      return res.status(403).json({ error: 'Insufficient permissions' })
    }
    next()
  }
}

export function publicWorkplaceProfile(actor: WorkplaceActor) {
  return {
    typ: actor.typ,
    adminId: actor.adminId,
    staffId: actor.staffId ?? null,
    email: actor.email,
    firstName: actor.firstName,
    lastName: actor.lastName,
    phone: actor.phone ?? null,
    role: actor.role ?? null,
    permissions: actor.permissions,
    canManageStaff: actor.canManageStaff,
  }
}
