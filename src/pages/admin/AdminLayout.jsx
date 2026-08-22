import React from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { formatRole, workplaceHome, workplacePath } from './workplacePaths'
import { AdminAvatar, NAV_ICONS } from './adminUi'
import './Admin.css'

function NavItem({ to, end, icon: Icon, children }) {
  return (
    <NavLink to={to} end={end}>
      <Icon size={18} aria-hidden="true" />
      {children}
    </NavLink>
  )
}

export default function AdminLayout() {
  const { user, isAdmin, can, logout } = useWorkplaceAuth()
  const navigate = useNavigate()

  const name =
    [user?.firstName, user?.lastName].filter(Boolean).join(' ') ||
    user?.email ||
    'Workplace user'
  const home = workplaceHome(user)

  const handleLogout = async () => {
    await logout()
    navigate('/admin/login', { replace: true })
  }

  return (
    <div className="admin-shell">
      <aside className="admin-sidebar">
        <div className="admin-brand">
          <span className="admin-brand-mark" aria-hidden="true">
            OE
          </span>
          <div>
            <strong>OrthoExpress</strong>
            <p>{isAdmin ? 'Practice admin' : formatRole(user?.role)}</p>
          </div>
        </div>

        <nav className="admin-nav" aria-label="Workplace">
          <NavItem to={home} end icon={NAV_ICONS.dashboard}>
            Dashboard
          </NavItem>
          {isAdmin && (
            <NavItem to="/admin/staff" icon={NAV_ICONS.staff}>
              Staff
            </NavItem>
          )}
          {can('appointments', 'read') && (
            <NavItem to={workplacePath(user, 'appointments')} icon={NAV_ICONS.appointments}>
              Appointments
            </NavItem>
          )}
          {can('orders', 'read') && (
            <NavItem to={workplacePath(user, 'orders')} icon={NAV_ICONS.orders}>
              Orders
            </NavItem>
          )}
          {can('prescriptions', 'read') && (
            <NavItem to={workplacePath(user, 'prescriptions')} icon={NAV_ICONS.prescriptions}>
              Prescriptions
            </NavItem>
          )}
          {can('demographics', 'read') && (
            <NavItem to={workplacePath(user, 'demographics')} icon={NAV_ICONS.demographics}>
              Demographics
            </NavItem>
          )}
          <NavItem to={workplacePath(user, 'profile')} icon={NAV_ICONS.profile}>
            Profile
          </NavItem>
        </nav>

        <div className="admin-sidebar-foot">
          <NavLink to={workplacePath(user, 'profile')} className="admin-user-chip">
            <AdminAvatar name={name} seed={user?.email} size="sm" />
            <div>
              <p className="admin-user-name">{name}</p>
              <p className="admin-user-email">{user?.email}</p>
            </div>
          </NavLink>
          <button type="button" className="admin-link-btn" onClick={handleLogout}>
            Sign out
          </button>
        </div>
      </aside>
      <div className="admin-main-wrap">
        <main className="admin-main">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
