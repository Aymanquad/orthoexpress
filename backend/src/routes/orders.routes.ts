import { Router } from 'express'
import { z } from 'zod'
import { requireAuth } from '../middleware/auth.js'
import { upsertShopOrder, listShopOrdersForPatient } from '../services/shopOrder.service.js'

const router = Router()

const orderSchema = z.object({
  id: z.string().min(1),
  createdAt: z.string().optional(),
  status: z.string().optional(),
  customer: z.object({
    firstName: z.string().optional(),
    lastName: z.string().optional(),
    email: z.string().optional(),
    phone: z.string().min(7),
    address: z.string().optional(),
    city: z.string().optional(),
    state: z.string().optional(),
    zip: z.string().optional(),
  }),
  items: z.array(z.unknown()),
  totals: z.object({
    subtotal: z.number().optional(),
    shipping: z.number().optional(),
    tax: z.number().optional(),
    total: z.number(),
  }),
  payment: z.unknown().optional(),
  lang: z.string().optional(),
})

/** Public — save/link a shop order to a patient by phone (upsert, never deletes) */
router.post('/', async (req, res) => {
  try {
    const data = orderSchema.parse(req.body)
    const result = await upsertShopOrder(data)
    return res.status(201).json({
      success: true,
      orderId: result.order.id,
      phone: result.patient.phone,
    })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unable to save order'
    return res.status(400).json({ error: message })
  }
})

/** Auth — list shop orders for logged-in patient */
router.get('/', requireAuth, async (req, res) => {
  const orders = await listShopOrdersForPatient(req.patient!.patientId)
  return res.json({ orders })
})

export default router
