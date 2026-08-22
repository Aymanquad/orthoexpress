import { Router } from 'express'
import { z } from 'zod'
import { PrescriptionStatus } from '@prisma/client'
import { prisma } from '../lib/prisma.js'
import { auditCreate, auditUpdate, publicAuditFields } from '../lib/workplaceAudit.js'
import {
  requirePermission,
  requireWorkplaceAuth,
} from '../middleware/workplaceAuth.js'

const router = Router()
router.use(requireWorkplaceAuth)

const createSchema = z.object({
  patientId: z.string().min(1),
  medication: z.string().trim().min(1).max(160),
  dosage: z.string().trim().min(1).max(120),
  frequency: z.string().trim().max(120).optional().nullable(),
  instructions: z.string().trim().max(500).optional().nullable(),
  prescribedBy: z.string().trim().max(120).optional().nullable(),
  status: z.nativeEnum(PrescriptionStatus).optional(),
  startsAt: z.string().datetime().optional().nullable(),
  endsAt: z.string().datetime().optional().nullable(),
  notes: z.string().trim().max(500).optional().nullable(),
})

const updateSchema = createSchema.partial().omit({ patientId: true })

function publicRx(row: {
  id: string
  patientId: string
  medication: string
  dosage: string
  frequency: string | null
  instructions: string | null
  prescribedBy: string | null
  status: PrescriptionStatus
  startsAt: Date | null
  endsAt: Date | null
  notes: string | null
  createdByType: string | null
  createdById: string | null
  createdByName: string | null
  updatedByType: string | null
  updatedById: string | null
  updatedByName: string | null
  createdAt: Date
  updatedAt: Date
  patient?: {
    id: string
    phone: string
    firstName: string | null
    lastName: string | null
  }
}) {
  return {
    id: row.id,
    patientId: row.patientId,
    medication: row.medication,
    dosage: row.dosage,
    frequency: row.frequency,
    instructions: row.instructions,
    prescribedBy: row.prescribedBy,
    status: row.status,
    startsAt: row.startsAt?.toISOString() ?? null,
    endsAt: row.endsAt?.toISOString() ?? null,
    notes: row.notes,
    ...publicAuditFields(row),
    patient: row.patient
      ? {
          id: row.patient.id,
          phone: row.patient.phone,
          firstName: row.patient.firstName,
          lastName: row.patient.lastName,
        }
      : undefined,
  }
}

const patientSelect = {
  id: true,
  phone: true,
  firstName: true,
  lastName: true,
}

router.get('/', requirePermission('prescriptions', 'read'), async (req, res) => {
  const status = typeof req.query.status === 'string' ? req.query.status : undefined
  const patientId = typeof req.query.patientId === 'string' ? req.query.patientId : undefined
  const where: Record<string, unknown> = {}
  if (status && Object.values(PrescriptionStatus).includes(status as PrescriptionStatus)) {
    where.status = status
  }
  if (patientId) where.patientId = patientId

  const prescriptions = await prisma.prescription.findMany({
    where,
    include: { patient: { select: patientSelect } },
    orderBy: [{ createdAt: 'desc' }],
    take: 200,
  })
  return res.json({ prescriptions: prescriptions.map(publicRx) })
})

router.post('/', requirePermission('prescriptions', 'write'), async (req, res) => {
  try {
    const data = createSchema.parse(req.body)
    const patient = await prisma.patient.findUnique({ where: { id: data.patientId } })
    if (!patient) return res.status(404).json({ error: 'Patient not found' })
    const audit = auditCreate(req.workplace!)
    const created = await prisma.prescription.create({
      data: {
        patientId: data.patientId,
        medication: data.medication,
        dosage: data.dosage,
        frequency: data.frequency?.trim() || null,
        instructions: data.instructions?.trim() || null,
        prescribedBy: data.prescribedBy?.trim() || null,
        status: data.status ?? PrescriptionStatus.ACTIVE,
        startsAt: data.startsAt ? new Date(data.startsAt) : null,
        endsAt: data.endsAt ? new Date(data.endsAt) : null,
        notes: data.notes?.trim() || null,
        ...audit,
      },
      include: { patient: { select: patientSelect } },
    })
    return res.status(201).json({ prescription: publicRx(created) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to create prescription'
    return res.status(400).json({ error: message })
  }
})

router.patch('/:id', requirePermission('prescriptions', 'write'), async (req, res) => {
  try {
    const data = updateSchema.parse(req.body)
    const id = String(req.params.id)
    const existing = await prisma.prescription.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ error: 'Prescription not found' })
    const audit = auditUpdate(req.workplace!)
    const updated = await prisma.prescription.update({
      where: { id },
      data: {
        medication: data.medication,
        dosage: data.dosage,
        frequency: data.frequency === undefined ? undefined : data.frequency?.trim() || null,
        instructions: data.instructions === undefined ? undefined : data.instructions?.trim() || null,
        prescribedBy: data.prescribedBy === undefined ? undefined : data.prescribedBy?.trim() || null,
        status: data.status,
        startsAt: data.startsAt === undefined ? undefined : data.startsAt ? new Date(data.startsAt) : null,
        endsAt: data.endsAt === undefined ? undefined : data.endsAt ? new Date(data.endsAt) : null,
        notes: data.notes === undefined ? undefined : data.notes?.trim() || null,
        ...audit,
      },
      include: { patient: { select: patientSelect } },
    })
    return res.json({ prescription: publicRx(updated) })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to update prescription'
    return res.status(400).json({ error: message })
  }
})

export default router
