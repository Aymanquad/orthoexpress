import { Router } from 'express'
import { z } from 'zod'
import { prisma } from '../lib/prisma.js'
import { auditCreate, auditUpdate, publicAuditFields } from '../lib/workplaceAudit.js'
import {
  requirePermission,
  requireWorkplaceAuth,
} from '../middleware/workplaceAuth.js'

const router = Router()
router.use(requireWorkplaceAuth)

const demoSchema = z.object({
  dateOfBirth: z.string().trim().max(32).optional().nullable(),
  sex: z.string().trim().max(40).optional().nullable(),
  address: z.string().trim().max(200).optional().nullable(),
  city: z.string().trim().max(80).optional().nullable(),
  state: z.string().trim().max(40).optional().nullable(),
  country: z.string().trim().max(80).optional().nullable(),
  zip: z.string().trim().max(20).optional().nullable(),
  emergencyName: z.string().trim().max(120).optional().nullable(),
  emergencyPhone: z.string().trim().max(40).optional().nullable(),
  emergencyRelationship: z.string().trim().max(80).optional().nullable(),
  insuranceProvider: z.string().trim().max(120).optional().nullable(),
  insurancePolicyNumber: z.string().trim().max(80).optional().nullable(),
  allergies: z.string().trim().max(500).optional().nullable(),
  bloodType: z.string().trim().max(12).optional().nullable(),
  conditions: z.string().trim().max(500).optional().nullable(),
  notes: z.string().trim().max(500).optional().nullable(),
})

function publicDemo(row: {
  id: string
  patientId: string
  dateOfBirth: string | null
  sex: string | null
  address: string | null
  city: string | null
  state: string | null
  country: string | null
  zip: string | null
  emergencyName: string | null
  emergencyPhone: string | null
  emergencyRelationship: string | null
  insuranceProvider: string | null
  insurancePolicyNumber: string | null
  allergies: string | null
  bloodType: string | null
  conditions: string | null
  notes: string | null
  updatedByType: string | null
  updatedById: string | null
  updatedByName: string | null
  updatedAt: Date
}) {
  return {
    id: row.id,
    patientId: row.patientId,
    dateOfBirth: row.dateOfBirth,
    sex: row.sex,
    address: row.address,
    city: row.city,
    state: row.state,
    country: row.country,
    zip: row.zip,
    emergencyName: row.emergencyName,
    emergencyPhone: row.emergencyPhone,
    emergencyRelationship: row.emergencyRelationship,
    insuranceProvider: row.insuranceProvider,
    insurancePolicyNumber: row.insurancePolicyNumber,
    allergies: row.allergies,
    bloodType: row.bloodType,
    conditions: row.conditions,
    notes: row.notes,
    ...publicAuditFields(row),
  }
}

const patientSelect = {
  id: true,
  phone: true,
  firstName: true,
  lastName: true,
  email: true,
}

router.get('/patients', requirePermission('demographics', 'read'), async (req, res) => {
  const q = typeof req.query.q === 'string' ? req.query.q.trim().toLowerCase() : ''
  const patients = await prisma.patient.findMany({
    include: { demographics: true },
    orderBy: [{ lastName: 'asc' }, { firstName: 'asc' }],
    take: 200,
  })
  const mapped = patients
    .filter((p) => {
      if (!q) return true
      const hay = `${p.firstName || ''} ${p.lastName || ''} ${p.phone} ${p.email || ''}`.toLowerCase()
      return hay.includes(q)
    })
    .map((p) => ({
      id: p.id,
      phone: p.phone,
      firstName: p.firstName,
      lastName: p.lastName,
      email: p.email,
      demographics: p.demographics ? publicDemo(p.demographics) : null,
    }))
  return res.json({ patients: mapped })
})

router.patch('/:patientId', requirePermission('demographics', 'write'), async (req, res) => {
  try {
    const data = demoSchema.parse(req.body)
    const patientId = String(req.params.patientId)
    const patient = await prisma.patient.findUnique({
      where: { id: patientId },
      select: patientSelect,
    })
    if (!patient) return res.status(404).json({ error: 'Patient not found' })

    const audit = auditUpdate(req.workplace!)
    const payload = {
      dateOfBirth: data.dateOfBirth === undefined ? undefined : data.dateOfBirth?.trim() || null,
      sex: data.sex === undefined ? undefined : data.sex?.trim() || null,
      address: data.address === undefined ? undefined : data.address?.trim() || null,
      city: data.city === undefined ? undefined : data.city?.trim() || null,
      state: data.state === undefined ? undefined : data.state?.trim() || null,
      country: data.country === undefined ? undefined : data.country?.trim() || null,
      zip: data.zip === undefined ? undefined : data.zip?.trim() || null,
      emergencyName: data.emergencyName === undefined ? undefined : data.emergencyName?.trim() || null,
      emergencyPhone: data.emergencyPhone === undefined ? undefined : data.emergencyPhone?.trim() || null,
      emergencyRelationship:
        data.emergencyRelationship === undefined ? undefined : data.emergencyRelationship?.trim() || null,
      insuranceProvider:
        data.insuranceProvider === undefined ? undefined : data.insuranceProvider?.trim() || null,
      insurancePolicyNumber:
        data.insurancePolicyNumber === undefined ? undefined : data.insurancePolicyNumber?.trim() || null,
      allergies: data.allergies === undefined ? undefined : data.allergies?.trim() || null,
      bloodType: data.bloodType === undefined ? undefined : data.bloodType?.trim() || null,
      conditions: data.conditions === undefined ? undefined : data.conditions?.trim() || null,
      notes: data.notes === undefined ? undefined : data.notes?.trim() || null,
      ...audit,
    }

    const demographics = await prisma.patientDemographics.upsert({
      where: { patientId },
      create: { patientId, ...payload },
      update: payload,
    })
    return res.json({ patient: { ...patient, demographics: publicDemo(demographics) } })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to save demographics'
    return res.status(400).json({ error: message })
  }
})

export default router
