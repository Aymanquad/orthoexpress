import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../../components/PageMeta'
import { useLanguage } from '../../context/LanguageContext'
import { useAuth } from '../../context/AuthContext'
import { appointmentsApi, ordersApi } from '../../api/client'
import { formatPrice } from '../../data/products'
import { formatOrderDate } from '../../utils/orders'
import './Portal.css'

function formatDate(iso, lang) {
  if (!iso) return '—'
  return new Date(iso).toLocaleString(lang === 'es' ? 'es-US' : 'en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  })
}

function StatusBadge({ status, t }) {
  return (
    <span className={`portal-status portal-status--${status}`}>
      {t(`portal.status.${status}`)}
    </span>
  )
}

function AppointmentCard({ appt, t, lang }) {
  const dateLabel = appt.scheduledAt
    ? formatDate(appt.scheduledAt, lang)
    : appt.preferredAt || '—'

  return (
    <article className="portal-appt-card">
      <div className="portal-appt-main">
        <h3>{appt.serviceName}</h3>
        <p className="portal-appt-meta">{appt.locationName}</p>
        <p className="portal-appt-detail">
          {t('portal.appointments.date')}: {dateLabel}
        </p>
        {appt.providerName && (
          <p className="portal-appt-detail">
            {t('portal.appointments.provider')}: {appt.providerName}
          </p>
        )}
      </div>
      <StatusBadge status={appt.status} t={t} />
    </article>
  )
}

const PortalDashboard = () => {
  const { t, lang } = useLanguage()
  const { patient, logout } = useAuth()
  const [appointments, setAppointments] = useState([])
  const [shopOrders, setShopOrders] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([
      appointmentsApi.list('upcoming').then((data) => data.appointments.slice(0, 3)).catch(() => []),
      ordersApi.list().then((data) => (data.orders || []).slice(0, 3)).catch(() => []),
    ])
      .then(([appts, orders]) => {
        setAppointments(appts)
        setShopOrders(orders)
      })
      .finally(() => setLoading(false))
  }, [])

  const displayName = patient?.firstName || t('portal.dashboard.welcomeGuest')
  const welcome = patient?.firstName
    ? t('portal.dashboard.welcome').replace('{name}', patient.firstName)
    : t('portal.dashboard.welcomeGuest')

  return (
    <div className="portal-page portal-dashboard">
      <PageMeta title={t('portal.dashboard.title')} />

      <div className="container">
        <div className="portal-welcome">
          <h1>{welcome}</h1>
          <p className="portal-appt-meta">{displayName !== welcome ? patient?.phone : ''}</p>
        </div>

        <div className="portal-quick-actions">
          <Link to="/book-appointment" className="btn btn-primary">
            {t('portal.dashboard.bookCta')}
          </Link>
          <Link to="/portal/appointments" className="btn btn-outline">
            {t('portal.dashboard.viewAll')}
          </Link>
          <Link to="/orders" className="btn btn-outline">
            {t('portal.dashboard.myOrders')}
          </Link>
          <Link to="/portal/records" className="btn btn-outline">
            {t('portal.dashboard.myRecords')}
          </Link>
          <Link to="/contact-us" className="btn btn-outline">
            {t('portal.dashboard.contactClinic')}
          </Link>
        </div>

        <section className="portal-section">
          <h2>{t('portal.dashboard.upcoming')}</h2>
          {loading ? (
            <div className="portal-loading"><div className="portal-loading-spinner" /></div>
          ) : appointments.length === 0 ? (
            <div className="portal-empty">
              <p>{t('portal.dashboard.noUpcoming')}</p>
              <Link to="/book-appointment" className="btn btn-primary" style={{ marginTop: '1rem' }}>
                {t('portal.dashboard.bookCta')}
              </Link>
            </div>
          ) : (
            <div className="portal-appt-list">
              {appointments.map((appt) => (
                <AppointmentCard key={appt.id} appt={appt} t={t} lang={lang} />
              ))}
            </div>
          )}
        </section>

        <section className="portal-section">
          <h2>{t('portal.dashboard.shopOrders')}</h2>
          {loading ? null : shopOrders.length === 0 ? (
            <div className="portal-empty">
              <p>{t('portal.dashboard.noOrders')}</p>
              <Link to="/shop" className="btn btn-outline" style={{ marginTop: '1rem' }}>
                {t('shop.browseShop')}
              </Link>
            </div>
          ) : (
            <div className="portal-appt-list">
              {shopOrders.map((order) => (
                <article key={order.id} className="portal-appt-card">
                  <div className="portal-appt-main">
                    <h3>{order.id}</h3>
                    <p className="portal-appt-meta">{formatOrderDate(order.createdAt, lang)}</p>
                    <p className="portal-appt-detail">
                      {(order.items || []).length} {t('shop.items')} ·{' '}
                      {formatPrice(order.totals?.total || 0, lang)}
                    </p>
                  </div>
                  <Link to={`/order-success/${order.id}`} className="btn btn-outline btn-sm">
                    {t('shop.viewReceipt')}
                  </Link>
                </article>
              ))}
            </div>
          )}
        </section>

        <button type="button" className="btn btn-outline" onClick={logout}>
          {t('portal.dashboard.signOut')}
        </button>
      </div>
    </div>
  )
}

export default PortalDashboard
