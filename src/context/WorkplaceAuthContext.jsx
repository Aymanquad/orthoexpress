import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react'
import { workplaceApi } from '../api/workplace'

const WorkplaceAuthContext = createContext(null)

export function WorkplaceAuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  const refresh = useCallback(async () => {
    try {
      const data = await workplaceApi.me()
      setUser(data.user)
    } catch {
      setUser(null)
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    refresh()
  }, [refresh])

  const login = useCallback(async (email, password) => {
    const data = await workplaceApi.login(email, password)
    setUser(data.user)
    return data.user
  }, [])

  const logout = useCallback(async () => {
    try {
      await workplaceApi.logout()
    } finally {
      setUser(null)
    }
  }, [])

  const updateProfile = useCallback(async (payload) => {
    const data = await workplaceApi.updateProfile(payload)
    setUser(data.user)
    return data.user
  }, [])

  const can = useCallback(
    (module, access = 'read') => {
      if (!user) return false
      if (user.typ === 'admin' || user.canManageStaff) return true
      return Boolean(user.permissions?.[module]?.[access])
    },
    [user]
  )

  const value = useMemo(
    () => ({
      user,
      loading,
      isAuthenticated: Boolean(user),
      isAdmin: user?.typ === 'admin' || Boolean(user?.canManageStaff),
      login,
      logout,
      refresh,
      updateProfile,
      can,
    }),
    [user, loading, login, logout, refresh, updateProfile, can]
  )

  return (
    <WorkplaceAuthContext.Provider value={value}>{children}</WorkplaceAuthContext.Provider>
  )
}

export function useWorkplaceAuth() {
  const ctx = useContext(WorkplaceAuthContext)
  if (!ctx) throw new Error('useWorkplaceAuth must be used within WorkplaceAuthProvider')
  return ctx
}
