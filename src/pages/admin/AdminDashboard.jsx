import React, { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { FiActivity, FiCalendar, FiClipboard, FiPackage, FiUsers } from 'react-icons/fi'
import { workplaceApi } from '../../api/workplace'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { formatRole, workplacePath } from './workplacePaths'
import { AdminAvatar, personName, StatusBadge } from './adminUi'
import './Admin.css'

export default function AdminDashboard() {
  const { user, isAdmin, can } = useWorkplaceAuth()
  const [stats, setStats] = useState({
    staff: 0,
    appointments: 0,
    orders: 0,
    prescriptions: 0,
    loading: true,
  })
  const [upcoming, setUpcoming] = useState([])

  useEffect(() => {
    let cancelled = false
    ;(async () => {
      try {
        const [staffRes, apptRes, orderRes, rxRes] = await Promise.all([
          isAdmin ? workplaceApi.listStaff().catch(() => ({ staff: [] })) : Promise.resolve({ staff: [] }),
          can('appointments', 'read')
            ? workplaceApi.listAppointments().catch(() => ({ appointments: [] }))
            : Promise.resolve({ appointments: [] }),
          can('orders', 'read')
            ? workplaceApi.listOrders().catch(() => ({ orders: [] }))
            : Promise.resolve({ orders: [] }),
          can('prescriptions', 'read')
            ? workplaceApi.listPrescriptions().catch(() => ({ prescriptions: [] }))
            : Promise.resolve({ prescriptions: [] }),
        ])
        if (cancelled) return
        const appointments = apptRes.appointments || []
        const now = Date.now()
        const weekAgo = now - 7 * 24 * 60 * 60 * 1000
        setStats({
          staff: (staffRes.staff || []).filter((s) => s.isActive).length,
          appointments: appointments.length,
          appointmentsWeek: appointments.filter((a) => new Date(a.createdAt || a.scheduledAt || 0).getTime() >= weekAgo).length,
          orders: (orderRes.orders || []).length,
          prescriptions: (rxRes.prescriptions || []).filter((p) => p.status === 'ACTIVE').length,
          loading: false,
        })
        setUpcoming(
          appointments
            .filter((a) => a.status === 'SCHEDULED' || a.status === 'REQUESTED')
            .slice(0, 6)
        )
      } catch {
        if (!cancelled) setStats((s) => ({ ...s, loading: false }))
      }
    })()
    return () => {
      cancelled = true
    }
  }, [isAdmin, can])

  const greeting = user?.firstName
    ? `Welcome back, ${user.firstName}`
    : isAdmin
      ? 'Practice overview'
      : 'Your workspace'

  const cards = useMemo(() => {
    const list = []
    if (isAdmin) {
      list.push({
        to: '/admin/staff',
        label: 'Active staff',
        value: stats.staff,
        hint: 'Logins and access',
        icon: FiUsers,
        tone: 'navy',
      })
    }
    if (can('appointments', 'read')) {
      list.push({
        to: workplacePath(user, 'appointments'),
        label: 'Appointments',
        value: stats.appointments,
        hint: 'Requests and visits',
        icon: FiCalendar,
        tone: 'green',
        trend: stats.appointmentsWeek ? `+${stats.appointmentsWeek} this week` : null,
      })
    }
    if (can('orders', 'read')) {
      list.push({
        to: workplacePath(user, 'orders'),
        label: 'Shop orders',
        value: stats.orders,
        hint: 'Linked patient orders',
        icon: FiPackage,
        tone: 'sky',
      })
    }
    if (can('prescriptions', 'read')) {
      list.push({
        to: workplacePath(user, 'prescriptions'),
        label: 'Active Rx',
        value: stats.prescriptions,
        hint: 'Current medications',
        icon: FiClipboard,
        tone: 'amber',
      })
    }
    return list
  }, [isAdmin, can, stats, user])

  const statGridClass =
    cards.length >= 4 ? 'admin-stat-grid--4' : `admin-stat-grid--${Math.max(cards.length, 1)}`
  const dashLayoutClass = cards.length <= 3 ? 'admin-dash-grid--stacked' : ''
  const showQueue = can('appointments', 'read')

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-hero">
        <div>
          <p className="admin-kicker">{isAdmin ? 'Practice admin' : formatRole(user?.role)}</p>
          <h1>{greeting}</h1>
          <p className="admin-muted">{user?.email}</p>
        </div>
        <Link to={workplacePath(user, 'profile')} className="admin-secondary-btn">
          Edit profile
        </Link>
      </header>

      {stats.loading ? (
        <p className="admin-muted">Loading overview…</p>
      ) : (
        <div className={`admin-dash-grid ${dashLayoutClass}`.trim()}>
          {cards.length > 0 && (
            <div className="admin-dash-stats">
              <div className={`admin-stat-grid ${statGridClass}`}>
                {cards.map((card) => {
                  const Icon = card.icon
                  return (
                    <Link
                      key={card.label}
                      to={card.to}
                      className={`admin-stat-card admin-stat-card--${card.tone}`}
                    >
                      <div className="admin-stat-main">
                        <span className="admin-stat-icon" aria-hidden="true">
                          <Icon />
                        </span>
                        <div className="admin-stat-copy">
                          <span className="admin-stat-label">{card.label}</span>
                          <div className="admin-stat-metrics">
                            <strong>{card.value}</strong>
                            <span className={`admin-stat-trend${card.trend ? '' : ' is-empty'}`}>
                              {card.trend || '—'}
                            </span>
                          </div>
                          <em>{card.hint}</em>
                        </div>
                      </div>
                    </Link>
                  )
                })}
              </div>
              {(isAdmin || can('demographics', 'read') || can('appointments', 'read')) && (
                <div className="admin-quick-actions">
                  {isAdmin && (
                    <Link to="/admin/staff" className="admin-secondary-btn">
                      Manage staff
                    </Link>
                  )}
                  {can('appointments', 'read') && (
                    <Link to={workplacePath(user, 'appointments')} className="admin-secondary-btn">
                      View appointments
                    </Link>
                  )}
                  {can('demographics', 'read') && (
                    <Link to={workplacePath(user, 'demographics')} className="admin-secondary-btn">
                      Patient records
                    </Link>
                  )}
                </div>
              )}
            </div>
          )}

          {showQueue && (
            <section className="admin-panel admin-dash-queue">
              <h2>
                <FiActivity size={18} style={{ marginRight: 8, verticalAlign: '-2px' }} />
                Today’s queue
              </h2>
              {upcoming.length === 0 ? (
                <p className="admin-muted">No requested or scheduled visits right now.</p>
              ) : (
                <div className="admin-activity">
                  {upcoming.map((a) => {
                    const name = personName(a.patient, a.patient?.phone)
                    return (
                      <div key={a.id} className="admin-activity-row">
                        <AdminAvatar name={name} seed={a.patient?.phone || a.id} size="sm" />
                        <div className="admin-person-copy" style={{ flex: 1 }}>
                          <strong>{name}</strong>
                          <p className="admin-muted">
                            {a.serviceName} · {a.locationName}
                          </p>
                        </div>
                        <StatusBadge value={a.status} />
                      </div>
                    )
                  })}
                </div>
              )}
            </section>
          )}

          {!showQueue && cards.length === 0 && (
            <section className="admin-panel">
              <h2>Your workspace</h2>
              <p className="admin-muted">
                No modules are assigned yet. Contact your practice admin if you need access.
              </p>
            </section>
          )}
        </div>
      )}
    </div>
  )
}
