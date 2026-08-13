import { useCallback, useEffect, useState } from 'react'
import { readOrdersFromStorage } from '../context/CartContext'
import { ORDERS_UPDATED_EVENT } from '../utils/orders'

export function useOrders() {
  const [orders, setOrders] = useState(() => readOrdersFromStorage())

  const refreshOrders = useCallback(() => {
    setOrders(readOrdersFromStorage())
  }, [])

  useEffect(() => {
    refreshOrders()

    const handleUpdate = () => refreshOrders()
    window.addEventListener(ORDERS_UPDATED_EVENT, handleUpdate)
    window.addEventListener('storage', handleUpdate)

    return () => {
      window.removeEventListener(ORDERS_UPDATED_EVENT, handleUpdate)
      window.removeEventListener('storage', handleUpdate)
    }
  }, [refreshOrders])

  return { orders, orderCount: orders.length, refreshOrders }
}
