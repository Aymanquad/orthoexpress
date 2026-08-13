export const ORDERS_UPDATED_EVENT = 'orthoexpress:orders-updated'
export const PRODUCT_STATS_UPDATED_EVENT = 'orthoexpress:product-stats-updated'

const PRODUCT_STATS_KEY = 'orthoexpress_product_stats'

export function formatOrderDate(isoString, lang = 'en') {
  const locale = lang === 'es' ? 'es-US' : 'en-US'
  return new Intl.DateTimeFormat(locale, {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(isoString))
}

export function getOrderStatusInfo(order, t) {
  const provider = order.payment?.provider
  const status = order.status || 'confirmed'

  if (provider === 'demo') {
    return {
      label: t('shop.orderStatusDemoLabel'),
      tone: 'demo',
      description: t('shop.orderStatusDemoDesc'),
    }
  }

  if (provider === 'stripe') {
    return {
      label: status === 'confirmed' ? t('shop.orderStatusPaid') : status,
      tone: 'success',
      description: t('shop.orderStatusPaidDesc'),
    }
  }

  return {
    label: t('pages.orders.statusConfirmed'),
    tone: 'success',
    description: t('shop.orderStatusConfirmedDesc'),
  }
}

export function getOrderItemCount(order) {
  return order.items.reduce((total, item) => total + item.quantity, 0)
}

function readProductStats() {
  try {
    const stored = localStorage.getItem(PRODUCT_STATS_KEY)
    if (!stored) return {}
    const parsed = JSON.parse(stored)
    return typeof parsed === 'object' && parsed ? parsed : {}
  } catch {
    return {}
  }
}

function writeProductStats(stats) {
  localStorage.setItem(PRODUCT_STATS_KEY, JSON.stringify(stats))
}

export function getProductUnitsSold(productId, baseUnitsSold = 0) {
  const stats = readProductStats()
  const additional = stats[productId] || 0
  return baseUnitsSold + additional
}

export function recordOrderSales(orderItems) {
  const stats = readProductStats()

  orderItems.forEach((item) => {
    stats[item.productId] = (stats[item.productId] || 0) + item.quantity
  })

  writeProductStats(stats)
  window.dispatchEvent(new CustomEvent(PRODUCT_STATS_UPDATED_EVENT))
}

export function dispatchOrdersUpdated() {
  window.dispatchEvent(new CustomEvent(ORDERS_UPDATED_EVENT))
}
