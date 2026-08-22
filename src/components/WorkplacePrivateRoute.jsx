import React from 'react'
import { Navigate, useLocation, useParams } from 'react-router-dom'
import { useWorkplaceAuth } from '../context/WorkplaceAuthContext'
import { isAdminUser, staffSlug, workplaceHome } from '../pages/admin/workplacePaths'

const WorkplacePrivateRoute = ({
  children,
  requireAdmin = false,
  module,
  access = 'read',
}) => {
  const { isAuthenticated, loading, isAdmin, can, user } = useWorkplaceAuth()
  const location = useLocation()
  const params = useParams()

  if (loading) {
    return (
      <div className="admin-loading">
        <div className="admin-loading-spinner" aria-hidden="true" />
      </div>
    )
  }

  if (!isAuthenticated) {
    return <Navigate to="/admin/login" replace state={{ from: location.pathname }} />
  }

  const home = workplaceHome(user)
  const onAdminTree = location.pathname.startsWith('/admin')
  const onStaffTree = location.pathname.startsWith('/staff/')

  if (isAdminUser(user) && onStaffTree) {
    const rest = location.pathname.split('/').slice(4).join('/')
    return <Navigate to={rest ? `/admin/${rest}` : '/admin'} replace />
  }

  if (!isAdminUser(user) && onAdminTree) {
    const rest = location.pathname.replace(/^\/admin\/?/, '')
    if (rest === 'staff') return <Navigate to={home} replace />
    return <Navigate to={rest ? `${home}/${rest}` : home} replace />
  }

  if (!isAdminUser(user) && onStaffTree) {
    const expectedSlug = staffSlug(user)
    if (params.staffId && params.staffId !== user.staffId) {
      return <Navigate to={home} replace />
    }
    if (params.slug && params.slug !== expectedSlug) {
      const rest = location.pathname.split('/').slice(4).join('/')
      return <Navigate to={rest ? `${home}/${rest}` : home} replace />
    }
  }

  if (requireAdmin && !isAdmin) {
    return <Navigate to={home} replace />
  }

  if (module && !can(module, access)) {
    return <Navigate to={home} replace />
  }

  return children
}

export default WorkplacePrivateRoute
