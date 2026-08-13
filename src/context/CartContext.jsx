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
  } catch {
    // Ignore storage errors (private mode, quota, etc.)
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

export function saveOrderToStorage(order) {
  const orders = readOrdersFromStorage()
  orders.unshift(order)
  localStorage.setItem(ORDERS_STORAGE_KEY, JSON.stringify(orders))
  recordOrderSales(order.items)
  dispatchOrdersUpdated()
}

export function getOrderById(orderId) {
  return readOrdersFromStorage().find((order) => order.id === orderId)
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
