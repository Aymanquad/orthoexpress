import { prisma } from '../lib/prisma.js'
import { normalizePhone } from '../lib/phone.js'

export interface ShopOrderPayload {
  id: string
  createdAt?: string
  status?: string
  customer: {
    firstName?: string
    lastName?: string
    email?: string
    phone: string
    address?: string
    city?: string
    state?: string
    zip?: string
  }
  items: unknown[]
  totals: { subtotal?: number; shipping?: number; tax?: number; total: number }
  payment?: unknown
  lang?: string
}

export async function upsertShopOrder(order: ShopOrderPayload) {
  const phone = normalizePhone(order.customer.phone)
  const firstName = order.customer.firstName || null
  const lastName = order.customer.lastName || null
  const email = order.customer.email || null

  // Upsert only — never deletes. Phone may be corrected (e.g. typo on success page).
  const patient = await prisma.patient.upsert({
    where: { phone },
    create: { phone, firstName, lastName, email },
    update: {
      ...(firstName ? { firstName } : {}),
      ...(lastName ? { lastName } : {}),
      ...(email ? { email } : {}),
    },
  })

  const totalCents = Math.round((order.totals?.total || 0) * 100)
  const payload = { ...order, customer: { ...order.customer, phone } }

  const saved = await prisma.shopOrder.upsert({
    where: { id: order.id },
    create: {
      id: order.id,
      patientId: patient.id,
      phone,
      payloadJson: JSON.stringify(payload),
      totalCents,
      status: order.status || 'confirmed',
      createdAt: order.createdAt ? new Date(order.createdAt) : undefined,
    },
    update: {
      patientId: patient.id,
      phone,
      payloadJson: JSON.stringify(payload),
      totalCents,
      status: order.status || 'confirmed',
    },
  })

  return { patient, order: saved, payload }
}

export async function listShopOrdersForPatient(patientId: string) {
  const rows = await prisma.shopOrder.findMany({
    where: { patientId },
    orderBy: { createdAt: 'desc' },
  })

  return rows.map((row) => {
    try {
      return JSON.parse(row.payloadJson)
    } catch {
      return {
        id: row.id,
        createdAt: row.createdAt.toISOString(),
        status: row.status,
        customer: { phone: row.phone },
        items: [],
        totals: { total: row.totalCents / 100 },
      }
    }
  })
}

export async function attachPhoneToExistingOrder(orderId: string, phoneRaw: string, customerPatch?: Partial<ShopOrderPayload['customer']>) {
  const phone = normalizePhone(phoneRaw)
  const existing = await prisma.shopOrder.findUnique({ where: { id: orderId } })

  let payload: ShopOrderPayload
  if (existing) {
    try {
      payload = JSON.parse(existing.payloadJson)
    } catch {
      throw new Error('Corrupt order payload')
    }
  } else {
    throw new Error('Order not found on server — sync the full order first')
  }

  payload.customer = {
    ...payload.customer,
    ...customerPatch,
    phone,
  }

  return upsertShopOrder(payload)
}
