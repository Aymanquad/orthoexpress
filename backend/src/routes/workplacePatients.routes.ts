import { Router } from 'express'
import { prisma } from '../lib/prisma.js'
import { requireAnyModule, requireWorkplaceAuth } from '../middleware/workplaceAuth.js'

const router = Router()
router.use(requireWorkplaceAuth)
router.use(requireAnyModule(['demographics', 'prescriptions', 'appointments'], 'read'))

router.get('/', async (req, res) => {
  const q = typeof req.query.q === 'string' ? req.query.q.trim().toLowerCase() : ''
  const patients = await prisma.patient.findMany({
    orderBy: [{ lastName: 'asc' }, { firstName: 'asc' }],
    take: 200,
    select: {
      id: true,
      phone: true,
      firstName: true,
      lastName: true,
      email: true,
    },
  })
  const filtered = q
    ? patients.filter((p) =>
        `${p.firstName || ''} ${p.lastName || ''} ${p.phone} ${p.email || ''}`.toLowerCase().includes(q)
      )
    : patients
  return res.json({ patients: filtered })
})

export default router
