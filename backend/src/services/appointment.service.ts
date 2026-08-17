import type { AppointmentStatus } from '@prisma/client'
import { prisma } from '../lib/prisma.js'
import { normalizePhone, splitFullName } from '../lib/phone.js'

export type AppointmentFilter = 'upcoming' | 'past' | 'all'

export async function getAppointmentsForPatient(patientId: string, filter: AppointmentFilter = 'all') {
  const now = new Date()

  const where =
    filter === 'upcoming'
      ? {
          patientId,
          OR: [
            { status: 'REQUESTED' as AppointmentStatus },
            { status: 'SCHEDULED' as AppointmentStatus, scheduledAt: { gte: now } },
          ],
        }
      : filter === 'past'
        ? {
            patientId,
            OR: [
              { status: 'COMPLETED' as AppointmentStatus },
              { status: 'CANCELLED' as AppointmentStatus },
              { status: 'NO_SHOW' as AppointmentStatus },
              { status: 'SCHEDULED' as AppointmentStatus, scheduledAt: { lt: now } },
            ],
          }
        : { patientId }

  return prisma.appointment.findMany({
    where,
    orderBy: [{ scheduledAt: 'desc' }, { createdAt: 'desc' }],
  })
}

export async function getAppointmentById(patientId: string, id: string) {
  return prisma.appointment.findFirst({
    where: { id, patientId },
  })
}

export interface AppointmentRequestInput {
  firstName?: string
  lastName?: string
  name?: string
  phone: string
  email?: string
  locationName: string
  serviceName?: string
  preferredAt?: string
  reason?: string
  consent?: boolean
}

export async function createAppointmentRequest(input: AppointmentRequestInput) {
  const phone = normalizePhone(input.phone)

  let firstName = input.firstName
  let lastName = input.lastName
  if (input.name && !firstName) {
    const split = splitFullName(input.name)
    firstName = split.firstName
    lastName = split.lastName
  }

  const patient = await prisma.patient.upsert({
    where: { phone },
    create: {
      phone,
      firstName: firstName || null,
      lastName: lastName || null,
      email: input.email || null,
    },
    update: {
      ...(firstName ? { firstName } : {}),
      ...(lastName ? { lastName } : {}),
      ...(input.email ? { email: input.email } : {}),
    },
  })

  const appointment = await prisma.appointment.create({
    data: {
      patientId: patient.id,
      locationName: input.locationName,
      serviceName: input.serviceName || 'General visit',
      preferredAt: input.preferredAt || null,
      reason: input.reason || null,
      status: 'REQUESTED',
      source: 'book_form',
    },
  })

  return { patient, appointment }
}
