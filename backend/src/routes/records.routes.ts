import { Router } from 'express'
import { z } from 'zod'
import { requireAuth } from '../middleware/auth.js'
import { rateLimit } from '../middleware/rateLimit.js'
import { prisma } from '../lib/prisma.js'

const router = Router()
router.use(requireAuth)

const patientContactSchema = z.object({
  address: z.string().trim().max(200).optional().nullable(),
  city: z.string().trim().max(80).optional().nullable(),
  state: z.string().trim().max(40).optional().nullable(),
  country: z.string().trim().max(80).optional().nullable(),
  zip: z.string().trim().max(20).optional().nullable(),
  emergencyName: z.string().trim().max(120).optional().nullable(),
  emergencyPhone: z.string().trim().max(40).optional().nullable(),
  emergencyRelationship: z.string().trim().max(80).optional().nullable(),
})

function publicPatientDemo(d: {
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
  updatedAt: Date
}) {
  return {
    dateOfBirth: d.dateOfBirth,
    sex: d.sex,
    address: d.address,
    city: d.city,
    state: d.state,
    country: d.country,
    zip: d.zip,
    emergencyName: d.emergencyName,
    emergencyPhone: d.emergencyPhone,
    emergencyRelationship: d.emergencyRelationship,
    insuranceProvider: d.insuranceProvider,
    insurancePolicyNumber: d.insurancePolicyNumber,
    allergies: d.allergies,
    bloodType: d.bloodType,
    conditions: d.conditions,
    updatedAt: d.updatedAt.toISOString(),
  }
}

router.get('/prescriptions', async (req, res) => {
  const prescriptions = await prisma.prescription.findMany({
    where: { patientId: req.patient!.patientId },
    orderBy: [{ createdAt: 'desc' }],
  })
  return res.json({
    prescriptions: prescriptions.map((row) => ({
      id: row.id,
      medication: row.medication,
      dosage: row.dosage,
      frequency: row.frequency,
      instructions: row.instructions,
      prescribedBy: row.prescribedBy,
      status: row.status,
      startsAt: row.startsAt?.toISOString() ?? null,
      endsAt: row.endsAt?.toISOString() ?? null,
      createdAt: row.createdAt.toISOString(),
    })),
  })
})

router.get('/demographics', async (req, res) => {
  const patient = await prisma.patient.findUnique({
    where: { id: req.patient!.patientId },
    include: { demographics: true },
  })
  if (!patient) return res.status(404).json({ error: 'Patient not found' })
  const d = patient.demographics
  return res.json({
    patient: {
      id: patient.id,
      phone: patient.phone,
      firstName: patient.firstName,
      lastName: patient.lastName,
      email: patient.email,
    },
    demographics: d ? publicPatientDemo(d) : null,
  })
})

router.patch(
  '/demographics',
  rateLimit('patient-demo-update', 20, 60 * 60 * 1000),
  async (req, res) => {
    try {
      const data = patientContactSchema.parse(req.body)
      const patientId = req.patient!.patientId
      const patient = await prisma.patient.findUnique({
        where: { id: patientId },
        select: { id: true, phone: true, firstName: true, lastName: true, email: true },
      })
      if (!patient) return res.status(404).json({ error: 'Patient not found' })

      const payload = {
        address: data.address === undefined ? undefined : data.address?.trim() || null,
        city: data.city === undefined ? undefined : data.city?.trim() || null,
        state: data.state === undefined ? undefined : data.state?.trim() || null,
        country: data.country === undefined ? undefined : data.country?.trim() || null,
        zip: data.zip === undefined ? undefined : data.zip?.trim() || null,
        emergencyName: data.emergencyName === undefined ? undefined : data.emergencyName?.trim() || null,
        emergencyPhone: data.emergencyPhone === undefined ? undefined : data.emergencyPhone?.trim() || null,
        emergencyRelationship:
          data.emergencyRelationship === undefined ? undefined : data.emergencyRelationship?.trim() || null,
        updatedByType: 'patient',
        updatedById: patientId,
        updatedByName: [patient.firstName, patient.lastName].filter(Boolean).join(' ') || patient.phone,
      }

      const demographics = await prisma.patientDemographics.upsert({
        where: { patientId },
        create: { patientId, ...payload },
        update: payload,
      })

      return res.json({
        patient,
        demographics: publicPatientDemo(demographics),
      })
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unable to update contact info'
      return res.status(400).json({ error: message })
    }
  }
)

export default router
