import { PrismaClient, AppointmentStatus } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  const patients = [
    {
      phone: '+12135550100',
      firstName: 'Alex',
      lastName: 'Rivera',
      email: 'alex.rivera@example.com',
    },
    {
      phone: '+12135550200',
      firstName: 'Jordan',
      lastName: 'Kim',
      email: 'jordan.kim@example.com',
    },
    {
      phone: '+12135550300',
      firstName: 'Sam',
      lastName: 'Patel',
      email: 'sam.patel@example.com',
    },
  ]

  for (const p of patients) {
    await prisma.patient.upsert({
      where: { phone: p.phone },
      create: p,
      update: p,
    })
  }

  const alex = await prisma.patient.findUniqueOrThrow({ where: { phone: '+12135550100' } })
  const jordan = await prisma.patient.findUniqueOrThrow({ where: { phone: '+12135550200' } })

  const now = new Date()
  const inThreeDays = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000)
  const inTenDays = new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000)
  const lastWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
  const lastMonth = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000)

  const seedAppointments = [
    {
      patientId: alex.id,
      locationName: 'OrthoExpress Los Angeles',
      serviceName: 'Sports Medicine',
      providerName: 'Dr. Martinez',
      scheduledAt: inThreeDays,
      status: AppointmentStatus.SCHEDULED,
      source: 'seed',
    },
    {
      patientId: alex.id,
      locationName: 'OrthoExpress Los Angeles',
      serviceName: 'Follow-up visit',
      providerName: 'Dr. Martinez',
      scheduledAt: inTenDays,
      status: AppointmentStatus.SCHEDULED,
      source: 'seed',
    },
    {
      patientId: alex.id,
      locationName: 'OrthoExpress Los Angeles',
      serviceName: 'MRI review',
      scheduledAt: lastWeek,
      status: AppointmentStatus.COMPLETED,
      source: 'seed',
    },
    {
      patientId: jordan.id,
      locationName: 'OrthoExpress Berlin',
      serviceName: 'Knee pain evaluation',
      preferredAt: 'Next available morning',
      status: AppointmentStatus.REQUESTED,
      source: 'seed',
    },
    {
      patientId: jordan.id,
      locationName: 'OrthoExpress London',
      serviceName: 'Physical therapy referral',
      scheduledAt: lastMonth,
      status: AppointmentStatus.COMPLETED,
      source: 'seed',
    },
  ]

  await prisma.appointment.deleteMany({ where: { source: 'seed' } })
  await prisma.appointment.createMany({ data: seedAppointments })

  console.log('Seed complete.')
  console.log('Demo login phones (OTP logged in dev mode):')
  console.log('  +1 (213) 555-0100 — Alex Rivera')
  console.log('  +1 (213) 555-0200 — Jordan Kim')
  console.log('  +1 (213) 555-0300 — Sam Patel')
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(() => prisma.$disconnect())
