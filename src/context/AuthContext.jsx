import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react'
import { authApi, ordersApi } from '../api/client'
import { mergeOrdersIntoStorage, readOrdersFromStorage } from './CartContext'
import { syncOrderToServer } from '../utils/orderSync'

const AuthContext = createContext(null)

function phonesMatch(a, b) {
  const da = String(a || '').replace(/\D/g, '')
  const db = String(b || '').replace(/\D/g, '')
  if (!da || !db) return false
  return da.slice(-10) === db.slice(-10)
}

/** Pull server orders into localStorage (additive). Also push local orders with matching phone. */
async function syncPatientOrders(patientPhone) {
  try {
    const data = await ordersApi.list()
    mergeOrdersIntoStorage(data.orders || [])
  } catch {
    // Server unavailable — keep local orders as-is
  }

  // Push any local orders for this phone that may not be on the server yet
  const local = readOrdersFromStorage()
  await Promise.all(
    local
      .filter((o) => phonesMatch(o.customer?.phone, patientPhone))
      .map((o) => syncOrderToServer(o))
  )
}

export function AuthProvider({ children }) {
  const [patient, setPatient] = useState(null)
  const [loading, setLoading] = useState(true)

  const refresh = useCallback(async () => {
    try {
      const data = await authApi.me()
      setPatient(data.patient)
      if (data.patient?.phone) {
        await syncPatientOrders(data.patient.phone)
      }
    } catch {
      setPatient(null)
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    refresh()
  }, [refresh])

  const login = useCallback(async (phone, code) => {
    const data = await authApi.verifyOtp(phone, code)
    setPatient(data.patient)
    if (data.patient?.phone) {
      await syncPatientOrders(data.patient.phone)
    }
    return data.patient
  }, [])

  const logout = useCallback(async () => {
    await authApi.logout()
    setPatient(null)
    // Never touch cart or orders in localStorage on logout
  }, [])

  const value = useMemo(
    () => ({
      patient,
      loading,
      isAuthenticated: Boolean(patient),
      login,
      logout,
      refresh,
    }),
    [patient, loading, login, logout, refresh]
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
