import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react'
import { getProductById } from '../data/products'
import { dispatchOrdersUpdated, recordOrderSales } from '../utils/orders'

const CART_STORAGE_KEY = 'orthoexpress_cart'
const ORDERS_STORAGE_KEY = 'orthoexpress_orders'

const CartContext = createContext(null)

function readCartFromStorage() {
  try {
    const stored = localStorage.getItem(CART_STORAGE_KEY)
    if (!stored) return []
    const parsed = JSON.parse(stored)
    return Array.isArray(parsed) ? parsed : []
  } catch {
    return []
  }
}

function writeCartToStorage(items) {
  try {
    localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(items))
    return true
  } catch {
    return false
  }
}

export function readOrdersFromStorage() {
  try {
    const stored = localStorage.getItem(ORDERS_STORAGE_KEY)
    if (!stored) return []
    const parsed = JSON.parse(stored)
    return Array.isArray(parsed) ? parsed : []
  } catch {
    return []
  }
}

/**
 * Durable write: persists then verifies the order id is readable back.
 * Never wipes the list — callers must pass the full intended array.
 */
function writeOrdersToStorage(orders) {
  if (!Array.isArray(orders)) return false
  try {
    const serialized = JSON.stringify(orders)
    localStorage.setItem(ORDERS_STORAGE_KEY, serialized)
    const verify = localStorage.getItem(ORDERS_STORAGE_KEY)
    if (verify !== serialized) return false
    dispatchOrdersUpdated()
    return true
  } catch {
    return false
  }
}

function customerPhoneDigits(phone) {
  return String(phone || '').replace(/\D/g, '')
}

/**
 * Additive save: never deletes other orders.
 * Returns { ok, order } — checkout must NOT clear cart unless ok.
 */
export function saveOrderToStorage(order) {
  if (!order?.id) return { ok: false, order: null }

  const orders = readOrdersFromStorage()
  const index = orders.findIndex((o) => o.id === order.id)
  const isNew = index < 0

  if (index >= 0) {
    const prev = orders[index]
    orders[index] = {
      ...prev,
      ...order,
      customer: { ...(prev.customer || {}), ...(order.customer || {}) },
      items: order.items?.length ? order.items : prev.items,
      totals: order.totals || prev.totals,
    }
  } else {
    orders.unshift(order)
  }

  const ok = writeOrdersToStorage(orders)
  if (!ok) return { ok: false, order: null }

  if (isNew && order.items?.length) {
    try {
      recordOrderSales(order.items)
    } catch {
      // Stats are secondary — order is already saved
    }
  }

  return { ok: true, order: getOrderById(order.id) }
}

/**
 * Merge remote orders into localStorage without removing any local orders.
 * - New remote ids are added
 * - Existing local ids are kept (local wins for items/totals)
 * - Missing local customer fields (esp. phone) are filled from remote
 */
export function mergeOrdersIntoStorage(remoteOrders = []) {
  if (!Array.isArray(remoteOrders) || remoteOrders.length === 0) {
    return readOrdersFromStorage()
  }

  const local = readOrdersFromStorage()
  const byId = new Map(local.map((o) => [o.id, o]))

  remoteOrders.forEach((remote) => {
    if (!remote?.id) return
    const existing = byId.get(remote.id)

    if (!existing) {
      byId.set(remote.id, remote)
      return
    }

    const localCustomer = existing.customer || {}
    const remoteCustomer = remote.customer || {}
    const localPhone = customerPhoneDigits(localCustomer.phone)

    byId.set(remote.id, {
      ...remote,
      ...existing,
      items: existing.items?.length ? existing.items : remote.items || [],
      totals: existing.totals || remote.totals,
      payment: existing.payment || remote.payment,
      customer: {
        firstName: localCustomer.firstName || remoteCustomer.firstName,
        lastName: localCustomer.lastName || remoteCustomer.lastName,
        email: localCustomer.email || remoteCustomer.email,
        address: localCustomer.address || remoteCustomer.address,
        city: localCustomer.city || remoteCustomer.city,
        state: localCustomer.state || remoteCustomer.state,
        zip: localCustomer.zip || remoteCustomer.zip,
        phone: localPhone ? localCustomer.phone : remoteCustomer.phone || localCustomer.phone,
      },
    })
  })

  const merged = Array.from(byId.values()).sort(
    (a, b) => new Date(b.createdAt || 0).getTime() - new Date(a.createdAt || 0).getTime()
  )

  writeOrdersToStorage(merged)
  return readOrdersFromStorage()
}

export function updateOrderInStorage(orderId, patch) {
  const orders = readOrdersFromStorage()
  const index = orders.findIndex((o) => o.id === orderId)
  if (index < 0) return null

  const prev = orders[index]
  orders[index] = {
    ...prev,
    ...patch,
    customer: patch.customer ? { ...(prev.customer || {}), ...patch.customer } : prev.customer,
    items: patch.items?.length ? patch.items : prev.items,
    totals: patch.totals || prev.totals,
  }

  const ok = writeOrdersToStorage(orders)
  if (!ok) return null
  return orders[index]
}

export function getOrderById(orderId) {
  return readOrdersFromStorage().find((order) => order.id === orderId)
}

/** Confirm an order id still exists in storage (post-save check). */
export function orderExistsInStorage(orderId) {
  return Boolean(getOrderById(orderId))
}

export function CartProvider({ children }) {
  const [items, setItems] = useState(() => readCartFromStorage())

  useEffect(() => {
    writeCartToStorage(items)
  }, [items])

  const addToCart = useCallback((productId, quantity = 1) => {
    if (!getProductById(productId)) return

    setItems((prev) => {
      const existing = prev.find((item) => item.productId === productId)
      if (existing) {
        return prev.map((item) =>
          item.productId === productId
            ? { ...item, quantity: item.quantity + quantity }
            : item
        )
      }
      return [...prev, { productId, quantity }]
    })
  }, [])

  const removeFromCart = useCallback((productId) => {
    setItems((prev) => prev.filter((item) => item.productId !== productId))
  }, [])

  const updateQuantity = useCallback((productId, quantity) => {
    if (quantity < 1) {
      setItems((prev) => prev.filter((item) => item.productId !== productId))
      return
    }

    setItems((prev) =>
      prev.map((item) =>
        item.productId === productId ? { ...item, quantity } : item
      )
    )
  }, [])

  const clearCart = useCallback(() => setItems([]), [])

  const cartItems = useMemo(
    () =>
      items
        .map((item) => {
          const product = getProductById(item.productId)
          if (!product) return null
          return {
            ...item,
            product,
            lineTotal: product.price * item.quantity,
          }
        })
        .filter(Boolean),
    [items]
  )

  const cartCount = useMemo(
    () => items.reduce((total, item) => total + item.quantity, 0),
    [items]
  )

  const subtotal = useMemo(
    () => cartItems.reduce((total, item) => total + item.lineTotal, 0),
    [cartItems]
  )

  const value = useMemo(
    () => ({
      items,
      cartItems,
      cartCount,
      subtotal,
      addToCart,
      removeFromCart,
      updateQuantity,
      clearCart,
    }),
    [items, cartItems, cartCount, subtotal, addToCart, removeFromCart, updateQuantity, clearCart]
  )

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>
}

export function useCart() {
  const context = useContext(CartContext)
  if (!context) {
    throw new Error('useCart must be used within a CartProvider')
  }
  return context
}
