import { Router } from 'express'
import { z } from 'zod'
import { prisma } from '../lib/prisma.js'
import {
  requirePermission,
  requireWorkplaceAuth,
} from '../middleware/workplaceAuth.js'

const router = Router()

const updateSchema = z.object({
  status: z.string().min(1).optional(),
})

function orderPublic(o: {
  id: string
  patientId: string
  phone: string
  payloadJson: string
  totalCents: number
  status: string
  createdAt: Date
  updatedAt: Date
  patient?: {
    id: string
    phone: string
    firstName: string | null
    lastName: string | null
    email: string | null
  }
}) {
  let payload: unknown = null
  try {
    payload = JSON.parse(o.payloadJson)
  } catch {
    payload = null
  }
  return {
    id: o.id,
    patientId: o.patientId,
    phone: o.phone,
    totalCents: o.totalCents,
    status: o.status,
    payload,
    createdAt: o.createdAt.toISOString(),
    updatedAt: o.updatedAt.toISOString(),
    patient: o.patient
      ? {
          id: o.patient.id,
          phone: o.patient.phone,
          firstName: o.patient.firstName,
          lastName: o.patient.lastName,
          email: o.patient.email,
        }
      : undefined,
  }
}

router.use(requireWorkplaceAuth)

router.get('/', requirePermission('orders', 'read'), async (_req, res) => {
  const orders = await prisma.shopOrder.findMany({
    include: {
      patient: {
        select: {
          id: true,
          phone: true,
          firstName: true,
          lastName: true,
          email: true,
        },
      },
    },
    orderBy: [{ createdAt: 'desc' }],
    take: 200,
  })
  return res.json({ orders: orders.map(orderPublic) })
})

router.patch('/:id', requirePermission('orders', 'write'), async (req, res) => {
  try {
    const data = updateSchema.parse(req.body)
    const id = String(req.params.id)
    const existing = await prisma.shopOrder.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ error: 'Order not found' })

    const updated = await prisma.shopOrder.update({
      where: { id },
      data: {
        status: data.status,
      },
      include: {
        patient: {
          select: {
            id: true,
            phone: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        },
      },
    })
    return res.json({ order: orderPublic(updated) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to update order'
    return res.status(400).json({ error: message })
  }
})

export default router
