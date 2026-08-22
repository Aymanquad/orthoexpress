import { Router } from 'express'
import bcrypt from 'bcryptjs'
import { z } from 'zod'
import { StaffRole } from '@prisma/client'
import { prisma } from '../lib/prisma.js'
import {
  requireAdmin,
  requireWorkplaceAuth,
} from '../middleware/workplaceAuth.js'
import {
  normalizePermissionsInput,
  parsePermissions,
  serializePermissions,
} from '../lib/permissions.js'

const router = Router()

const moduleAccessSchema = z
  .object({
    read: z.boolean().optional(),
    write: z.boolean().optional(),
  })
  .optional()

const permissionsSchema = z.object({
  appointments: moduleAccessSchema,
  orders: moduleAccessSchema,
  prescriptions: moduleAccessSchema,
  demographics: moduleAccessSchema,
})

const createSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  firstName: z.string().optional(),
  lastName: z.string().optional(),
  phone: z.string().optional(),
  role: z.nativeEnum(StaffRole).optional(),
  permissions: permissionsSchema.optional(),
  isActive: z.boolean().optional(),
})

const updateSchema = z.object({
  email: z.string().email().optional(),
  password: z.string().min(6).optional(),
  firstName: z.string().nullable().optional(),
  lastName: z.string().nullable().optional(),
  phone: z.string().nullable().optional(),
  role: z.nativeEnum(StaffRole).optional(),
  permissions: permissionsSchema.optional(),
  isActive: z.boolean().optional(),
})

function staffPublic(staff: {
  id: string
  adminId: string
  email: string
  firstName: string | null
  lastName: string | null
  phone: string | null
  role: StaffRole
  permissions: string
  isActive: boolean
  createdAt: Date
  updatedAt: Date
}) {
  return {
    id: staff.id,
    adminId: staff.adminId,
    email: staff.email,
    firstName: staff.firstName,
    lastName: staff.lastName,
    phone: staff.phone,
    role: staff.role,
    permissions: parsePermissions(staff.permissions),
    isActive: staff.isActive,
    createdAt: staff.createdAt.toISOString(),
    updatedAt: staff.updatedAt.toISOString(),
  }
}

router.use(requireWorkplaceAuth, requireAdmin)

router.get('/', async (req, res) => {
  const adminId = req.workplace!.adminId
  const staff = await prisma.staff.findMany({
    where: { adminId },
    orderBy: [{ isActive: 'desc' }, { createdAt: 'desc' }],
  })
  return res.json({ staff: staff.map(staffPublic) })
})

router.post('/', async (req, res) => {
  try {
    const data = createSchema.parse(req.body)
    const email = data.email.trim().toLowerCase()
    const existingAdmin = await prisma.admin.findUnique({ where: { email } })
    if (existingAdmin) {
      return res.status(409).json({ error: 'Email already in use' })
    }
    const existingStaff = await prisma.staff.findUnique({ where: { email } })
    if (existingStaff) {
      return res.status(409).json({ error: 'Email already in use' })
    }

    const permissions = normalizePermissionsInput(data.permissions)
    const passwordHash = await bcrypt.hash(data.password, 10)
    const created = await prisma.staff.create({
      data: {
        adminId: req.workplace!.adminId,
        email,
        passwordHash,
        firstName: data.firstName?.trim() || null,
        lastName: data.lastName?.trim() || null,
        phone: data.phone?.trim() || null,
        role: data.role ?? StaffRole.FRONT_DESK,
        permissions: serializePermissions(permissions),
        isActive: data.isActive ?? true,
      },
    })
    return res.status(201).json({ staff: staffPublic(created) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to create staff'
    return res.status(400).json({ error: message })
  }
})

router.patch('/:id', async (req, res) => {
  try {
    const data = updateSchema.parse(req.body)
    const existing = await prisma.staff.findFirst({
      where: { id: req.params.id, adminId: req.workplace!.adminId },
    })
    if (!existing) return res.status(404).json({ error: 'Staff not found' })

    if (data.email) {
      const email = data.email.trim().toLowerCase()
      if (email !== existing.email) {
        const clashAdmin = await prisma.admin.findUnique({ where: { email } })
        const clashStaff = await prisma.staff.findUnique({ where: { email } })
        if (clashAdmin || clashStaff) {
          return res.status(409).json({ error: 'Email already in use' })
        }
      }
    }

    const updated = await prisma.staff.update({
      where: { id: existing.id },
      data: {
        email: data.email ? data.email.trim().toLowerCase() : undefined,
        passwordHash: data.password ? await bcrypt.hash(data.password, 10) : undefined,
        firstName: data.firstName === undefined ? undefined : data.firstName?.trim() || null,
        lastName: data.lastName === undefined ? undefined : data.lastName?.trim() || null,
        phone: data.phone === undefined ? undefined : data.phone?.trim() || null,
        role: data.role,
        permissions:
          data.permissions === undefined
            ? undefined
            : serializePermissions(normalizePermissionsInput(data.permissions)),
        isActive: data.isActive,
      },
    })
    return res.json({ staff: staffPublic(updated) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to update staff'
    return res.status(400).json({ error: message })
  }
})

router.delete('/:id', async (req, res) => {
  const existing = await prisma.staff.findFirst({
    where: { id: req.params.id, adminId: req.workplace!.adminId },
  })
  if (!existing) return res.status(404).json({ error: 'Staff not found' })

  // Soft-deactivate by default; hard delete only when explicitly requested
  if (req.query.hard === '1') {
    await prisma.staff.delete({ where: { id: existing.id } })
    return res.json({ success: true, deleted: true })
  }

  const updated = await prisma.staff.update({
    where: { id: existing.id },
    data: { isActive: false },
  })
  return res.json({ staff: staffPublic(updated), deactivated: true })
})

export default router
