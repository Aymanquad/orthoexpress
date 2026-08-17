import { Router } from 'express'
import { z } from 'zod'
import { requireAuth } from '../middleware/auth.js'
import {
  createAppointmentRequest,
  getAppointmentById,
  getAppointmentsForPatient,
} from '../services/appointment.service.js'

const router = Router()

const requestSchema = z.object({
  firstName: z.string().optional(),
  lastName: z.string().optional(),
  name: z.string().optional(),
  phone: z.string().min(7),
  email: z.string().email().optional().or(z.literal('')),
  locationName: z.string().min(1),
  serviceName: z.string().optional(),
  preferredAt: z.string().optional(),
  reason: z.string().optional(),
  consent: z.boolean().optional(),
})

router.get('/', requireAuth, async (req, res) => {
  const filter = (req.query.filter as 'upcoming' | 'past' | 'all') || 'all'
  const appointments = await getAppointmentsForPatient(req.patient!.patientId, filter)
  return res.json({ appointments })
})

router.get('/:id', requireAuth, async (req, res) => {
  const appointment = await getAppointmentById(req.patient!.patientId, req.params.id)
  if (!appointment) return res.status(404).json({ error: 'Appointment not found' })
  return res.json({ appointment })
})

router.post('/request', async (req, res) => {
  try {
    const data = requestSchema.parse(req.body)
    if (!data.consent) {
      return res.status(400).json({ error: 'Consent is required' })
    }
    const result = await createAppointmentRequest(data)
    return res.status(201).json({
      success: true,
      appointmentId: result.appointment.id,
      message: 'Appointment request received',
    })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to submit request'
    return res.status(400).json({ error: message })
  }
})

export default router
