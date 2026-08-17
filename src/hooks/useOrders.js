import { useCallback, useEffect, useMemo, useState } from 'react'
import { readOrdersFromStorage, mergeOrdersIntoStorage } from '../context/CartContext'
import { ORDERS_UPDATED_EVENT } from '../utils/orders'
import { useAuth } from '../context/AuthContext'
import { ordersApi } from '../api/client'

function phonesMatch(a, b) {
  const da = String(a || '').replace(/\D/g, '')
  const db = String(b || '').replace(/\D/g, '')
  if (!da || !db) return false
  return da.slice(-10) === db.slice(-10)
}

/**
 * Orders for the My Orders page:
 * - Logged out → no orders exposed (UI shows login prompt)
 * - Logged in → only orders matching the patient's phone (local + server merge)
 */
export function useOrders() {
  const { isAuthenticated, patient, loading: authLoading } = useAuth()
  const [allLocal, setAllLocal] = useState(() => readOrdersFromStorage())
  const [serverOrders, setServerOrders] = useState([])
  const [fetching, setFetching] = useState(false)

  const refreshLocal = useCallback(() => {
    setAllLocal(readOrdersFromStorage())
  }, [])

  useEffect(() => {
    refreshLocal()
    const handleUpdate = () => refreshLocal()
    window.addEventListener(ORDERS_UPDATED_EVENT, handleUpdate)
    window.addEventListener('storage', handleUpdate)
    return () => {
      window.removeEventListener(ORDERS_UPDATED_EVENT, handleUpdate)
      window.removeEventListener('storage', handleUpdate)
    }
  }, [refreshLocal])

  useEffect(() => {
    if (!isAuthenticated || !patient?.phone) {
      setServerOrders([])
      setFetching(false)
      return undefined
    }

    let cancelled = false
    setFetching(true)

    ordersApi
      .list()
      .then((data) => {
        if (cancelled) return
        const remote = data.orders || []
        mergeOrdersIntoStorage(remote)
        setServerOrders(remote)
        refreshLocal()
      })
      .catch(() => {
        if (!cancelled) setServerOrders([])
      })
      .finally(() => {
        if (!cancelled) setFetching(false)
      })

    return () => {
      cancelled = true
    }
  }, [isAuthenticated, patient?.phone, refreshLocal])

  const orders = useMemo(() => {
    if (!isAuthenticated || !patient?.phone) return []

    const byId = new Map()

    // Server list is authoritative for this patient
    serverOrders.forEach((o) => {
      if (o?.id) byId.set(o.id, o)
    })

    // Include local orders that match this phone (linked at checkout / success)
    allLocal.forEach((o) => {
      if (!o?.id) return
      if (!phonesMatch(o.customer?.phone, patient.phone)) return
      if (!byId.has(o.id)) byId.set(o.id, o)
      else {
        // Prefer local detail if richer, keep phone-matched only
        const existing = byId.get(o.id)
        byId.set(o.id, {
          ...existing,
          ...o,
          items: o.items?.length ? o.items : existing.items,
          totals: o.totals || existing.totals,
          customer: { ...(existing.customer || {}), ...(o.customer || {}) },
        })
      }
    })

    return Array.from(byId.values()).sort(
      (a, b) => new Date(b.createdAt || 0).getTime() - new Date(a.createdAt || 0).getTime()
    )
  }, [isAuthenticated, patient?.phone, allLocal, serverOrders])

  return {
    orders,
    orderCount: orders.length,
    requiresLogin: !authLoading && !isAuthenticated,
    loading: authLoading || (isAuthenticated && fetching),
    refreshOrders: refreshLocal,
  }
}
