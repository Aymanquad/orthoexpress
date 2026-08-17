import { ordersApi } from '../api/client'

/**
 * Persist order to API linked by phone.
 * Failures are non-fatal — localStorage remains the source of truth for the browser.
 */
export async function syncOrderToServer(order) {
  if (!order?.id || !order?.customer?.phone) {
    return { synced: false, reason: 'missing_phone' }
  }

  try {
    await ordersApi.save(order)
    return { synced: true }
  } catch (err) {
    console.warn('Order sync failed (local order kept):', err?.message || err)
    return { synced: false, reason: err?.message || 'api_error' }
  }
}
