import { Router } from 'express'
import { z } from 'zod'
import { AppointmentStatus } from '@prisma/client'
import { prisma } from '../lib/prisma.js'
import {
  requirePermission,
  requireWorkplaceAuth,
} from '../middleware/workplaceAuth.js'

const router = Router()

const updateSchema = z.object({
  status: z.nativeEnum(AppointmentStatus).optional(),
  providerName: z.string().nullable().optional(),
  scheduledAt: z.string().datetime().nullable().optional(),
  locationName: z.string().min(1).optional(),
  serviceName: z.string().min(1).optional(),
  reason: z.string().nullable().optional(),
})

function appointmentPublic(a: {
  id: string
  patientId: string
  locationName: string
  serviceName: string
  providerName: string | null
  scheduledAt: Date | null
  preferredAt: string | null
  reason: string | null
  status: AppointmentStatus
  source: string
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
  return {
    id: a.id,
    patientId: a.patientId,
    locationName: a.locationName,
    serviceName: a.serviceName,
    providerName: a.providerName,
    scheduledAt: a.scheduledAt?.toISOString() ?? null,
    preferredAt: a.preferredAt,
    reason: a.reason,
    status: a.status,
    source: a.source,
    createdAt: a.createdAt.toISOString(),
    updatedAt: a.updatedAt.toISOString(),
    patient: a.patient
      ? {
          id: a.patient.id,
          phone: a.patient.phone,
          firstName: a.patient.firstName,
          lastName: a.patient.lastName,
          email: a.patient.email,
        }
      : undefined,
  }
}

router.use(requireWorkplaceAuth)

router.get('/', requirePermission('appointments', 'read'), async (req, res) => {
  const status = typeof req.query.status === 'string' ? req.query.status : undefined
  const where =
    status && Object.values(AppointmentStatus).includes(status as AppointmentStatus)
      ? { status: status as AppointmentStatus }
      : {}

  const appointments = await prisma.appointment.findMany({
    where,
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
  return res.json({ appointments: appointments.map(appointmentPublic) })
})

router.patch('/:id', requirePermission('appointments', 'write'), async (req, res) => {
  try {
    const data = updateSchema.parse(req.body)
    const id = String(req.params.id)
    const existing = await prisma.appointment.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ error: 'Appointment not found' })

    const updated = await prisma.appointment.update({
      where: { id },
      data: {
        status: data.status,
        providerName:
          data.providerName === undefined ? undefined : data.providerName?.trim() || null,
        scheduledAt:
          data.scheduledAt === undefined
            ? undefined
            : data.scheduledAt
              ? new Date(data.scheduledAt)
              : null,
        locationName: data.locationName,
        serviceName: data.serviceName,
        reason: data.reason === undefined ? undefined : data.reason?.trim() || null,
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
    return res.json({ appointment: appointmentPublic(updated) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to update appointment'
    return res.status(400).json({ error: message })
  }
})

export default router
