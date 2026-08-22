import bcrypt from 'bcryptjs'
import { PrismaClient, AppointmentStatus, PrescriptionStatus } from '@prisma/client'

const prisma = new PrismaClient()

const DEMO_ADMIN_EMAIL = 'admin@orthoexpress.com'
const DEMO_ADMIN_PASSWORD = 'admin123'

async function main() {
  const passwordHash = await bcrypt.hash(DEMO_ADMIN_PASSWORD, 10)
  await prisma.admin.upsert({
    where: { email: DEMO_ADMIN_EMAIL },
    create: {
      email: DEMO_ADMIN_EMAIL,
      passwordHash,
      firstName: 'Practice',
      lastName: 'Admin',
      isActive: true,
    },
    update: {
      passwordHash,
      firstName: 'Practice',
      lastName: 'Admin',
      isActive: true,
    },
  })

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

  const sam = await prisma.patient.findUniqueOrThrow({ where: { phone: '+12135550300' } })

  await prisma.patientDemographics.upsert({
    where: { patientId: alex.id },
    create: {
      patientId: alex.id,
      dateOfBirth: '1992-04-18',
      sex: 'Male',
      address: '412 Sunset Blvd',
      city: 'Los Angeles',
      state: 'CA',
      country: 'USA',
      zip: '90028',
      emergencyName: 'Maya Rivera',
      emergencyPhone: '+12135550111',
      emergencyRelationship: 'Spouse',
      insuranceProvider: 'Blue Shield CA',
      insurancePolicyNumber: 'BS-8829104',
      allergies: 'Penicillin',
      bloodType: 'O+',
      conditions: 'Right ACL sprain (2024)',
      updatedByType: 'admin',
      updatedByName: 'Practice Admin',
    },
    update: {
      dateOfBirth: '1992-04-18',
      sex: 'Male',
      country: 'USA',
      emergencyRelationship: 'Spouse',
      insuranceProvider: 'Blue Shield CA',
      insurancePolicyNumber: 'BS-8829104',
      allergies: 'Penicillin',
      bloodType: 'O+',
      conditions: 'Right ACL sprain (2024)',
    },
  })

  await prisma.patientDemographics.upsert({
    where: { patientId: jordan.id },
    create: {
      patientId: jordan.id,
      dateOfBirth: '1988-11-02',
      sex: 'Female',
      city: 'Berlin',
      country: 'Germany',
      allergies: 'None known',
      conditions: 'Patellofemoral pain',
      emergencyName: 'Chris Kim',
      emergencyPhone: '+12135550211',
      emergencyRelationship: 'Sibling',
      insuranceProvider: 'AOK Berlin',
      insurancePolicyNumber: 'AOK-441029',
      updatedByType: 'admin',
      updatedByName: 'Practice Admin',
    },
    update: {
      dateOfBirth: '1988-11-02',
      sex: 'Female',
      country: 'Germany',
      emergencyRelationship: 'Sibling',
      allergies: 'None known',
    },
  })

  await prisma.prescription.deleteMany({
    where: { patientId: { in: [alex.id, jordan.id, sam.id] } },
  })
  await prisma.prescription.createMany({
    data: [
      {
        patientId: alex.id,
        medication: 'Naproxen',
        dosage: '500 mg twice daily',
        instructions: 'Take with food. Stop if stomach pain.',
        prescribedBy: 'Dr. Martinez',
        status: PrescriptionStatus.ACTIVE,
        startsAt: now,
      },
      {
        patientId: alex.id,
        medication: 'Meloxicam',
        dosage: '15 mg daily',
        frequency: 'Once daily',
        instructions: 'Completed post-MRI course.',
        prescribedBy: 'Dr. Martinez',
        status: PrescriptionStatus.COMPLETED,
        startsAt: lastMonth,
        endsAt: lastWeek,
        notes: 'Internal: patient tolerated well.',
        createdByName: 'Practice Admin',
      },
      {
        patientId: jordan.id,
        medication: 'Diclofenac gel',
        dosage: 'Apply 2–4 g to knee QID',
        frequency: 'Four times daily',
        instructions: 'Use after PT sessions.',
        prescribedBy: 'Dr. Chen',
        status: PrescriptionStatus.ACTIVE,
        startsAt: now,
      },
      {
        patientId: sam.id,
        medication: 'Cyclobenzaprine',
        dosage: '10 mg at bedtime',
        frequency: 'Once daily at night',
        instructions: 'Short course for muscle spasm.',
        prescribedBy: 'Dr. Patel',
        status: PrescriptionStatus.DISCONTINUED,
        startsAt: lastMonth,
        endsAt: lastWeek,
        notes: 'Stopped due to drowsiness.',
        createdByName: 'Practice Admin',
      },
    ],
  })

  console.log('Seed complete.')
  console.log('Demo login phones (OTP logged in dev mode):')
  console.log('  +1 (213) 555-0100 — Alex Rivera')
  console.log('  +1 (213) 555-0200 — Jordan Kim')
  console.log('  +1 (213) 555-0300 — Sam Patel')
  console.log('Workplace admin (email/password):')
  console.log(`  ${DEMO_ADMIN_EMAIL} / ${DEMO_ADMIN_PASSWORD}`)
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(() => prisma.$disconnect())
