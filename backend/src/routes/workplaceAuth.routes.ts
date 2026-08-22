import { Router } from 'express'
import bcrypt from 'bcryptjs'
import { z } from 'zod'
import { prisma } from '../lib/prisma.js'
import {
  clearWorkplaceCookie,
  publicWorkplaceProfile,
  requireWorkplaceAuth,
  setWorkplaceCookie,
  signWorkplaceToken,
} from '../middleware/workplaceAuth.js'
import { FULL_PERMISSIONS, parsePermissions } from '../lib/permissions.js'

const router = Router()

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
})

router.post('/login', async (req, res) => {
  try {
    const { email, password } = loginSchema.parse(req.body)
    const normalized = email.trim().toLowerCase()

    const admin = await prisma.admin.findUnique({ where: { email: normalized } })
    if (admin && admin.isActive) {
      const ok = await bcrypt.compare(password, admin.passwordHash)
      if (ok) {
        const token = signWorkplaceToken({ typ: 'admin', adminId: admin.id })
        setWorkplaceCookie(res, token)
        return res.json({
          token,
          user: publicWorkplaceProfile({
            typ: 'admin',
            adminId: admin.id,
            email: admin.email,
            firstName: admin.firstName,
            lastName: admin.lastName,
            phone: admin.phone,
            permissions: FULL_PERMISSIONS,
            canManageStaff: true,
          }),
        })
      }
    }

    const staff = await prisma.staff.findUnique({ where: { email: normalized } })
    if (staff && staff.isActive) {
      const ok = await bcrypt.compare(password, staff.passwordHash)
      if (ok) {
        const token = signWorkplaceToken({
          typ: 'staff',
          staffId: staff.id,
          adminId: staff.adminId,
          role: staff.role,
        })
        setWorkplaceCookie(res, token)
        return res.json({
          token,
          user: publicWorkplaceProfile({
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
          }),
        })
      }
    }

    return res.status(401).json({ error: 'Invalid email or password' })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Login failed'
    return res.status(400).json({ error: message })
  }
})

router.get('/me', requireWorkplaceAuth, (req, res) => {
  return res.json({ user: publicWorkplaceProfile(req.workplace!) })
})

const profileSchema = z.object({
  firstName: z.string().trim().max(80).optional(),
  lastName: z.string().trim().max(80).optional(),
  phone: z.string().trim().max(40).optional().nullable(),
  currentPassword: z.string().min(1).optional(),
  newPassword: z.string().min(6).optional(),
})

router.patch('/profile', requireWorkplaceAuth, async (req, res) => {
  try {
    const data = profileSchema.parse(req.body)
    const actor = req.workplace!

    if (data.newPassword) {
      if (!data.currentPassword) {
        return res.status(400).json({ error: 'Current password is required to set a new password' })
      }
      const hash =
        actor.typ === 'admin'
          ? (await prisma.admin.findUnique({ where: { id: actor.adminId } }))?.passwordHash
          : (
              await prisma.staff.findUnique({
                where: { id: actor.staffId! },
              })
            )?.passwordHash
      if (!hash) return res.status(404).json({ error: 'Account not found' })
      const ok = await bcrypt.compare(data.currentPassword, hash)
      if (!ok) return res.status(400).json({ error: 'Current password is incorrect' })
    }

    const patch = {
      firstName: data.firstName !== undefined ? data.firstName || null : undefined,
      lastName: data.lastName !== undefined ? data.lastName || null : undefined,
      phone: data.phone !== undefined ? data.phone || null : undefined,
      passwordHash: data.newPassword ? await bcrypt.hash(data.newPassword, 10) : undefined,
    }

    if (actor.typ === 'admin') {
      const admin = await prisma.admin.update({
        where: { id: actor.adminId },
        data: patch,
      })
      return res.json({
        user: publicWorkplaceProfile({
          typ: 'admin',
          adminId: admin.id,
          email: admin.email,
          firstName: admin.firstName,
          lastName: admin.lastName,
          phone: admin.phone,
          permissions: FULL_PERMISSIONS,
          canManageStaff: true,
        }),
      })
    }

    const staff = await prisma.staff.update({
      where: { id: actor.staffId! },
      data: patch,
    })
    return res.json({
      user: publicWorkplaceProfile({
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
      }),
    })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Profile update failed'
    return res.status(400).json({ error: message })
  }
})

router.post('/logout', (_req, res) => {
  clearWorkplaceCookie(res)
  return res.json({ success: true })
})

export default router
