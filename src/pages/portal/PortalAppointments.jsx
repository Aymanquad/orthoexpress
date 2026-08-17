import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../../components/PageMeta'
import { useLanguage } from '../../context/LanguageContext'
import { appointmentsApi } from '../../api/client'
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

const PortalAppointments = () => {
  const { t, lang } = useLanguage()
  const [filter, setFilter] = useState('upcoming')
  const [appointments, setAppointments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    setLoading(true)
    appointmentsApi.list(filter)
      .then((data) => setAppointments(data.appointments))
      .catch(() => setAppointments([]))
      .finally(() => setLoading(false))
  }, [filter])

  const tabs = [
    { key: 'upcoming', label: t('portal.appointments.upcoming') },
    { key: 'past', label: t('portal.appointments.past') },
    { key: 'all', label: t('portal.appointments.all') },
  ]

  return (
    <div className="portal-page portal-dashboard">
      <PageMeta title={t('portal.appointments.title')} />

      <div className="container">
        <div className="portal-welcome" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '1rem' }}>
          <h1>{t('portal.appointments.title')}</h1>
          <Link to="/portal" className="btn btn-outline btn-sm">
            ← {t('portal.myPortal')}
          </Link>
        </div>

        <div className="portal-tabs" role="tablist">
          {tabs.map((tab) => (
            <button
              key={tab.key}
              type="button"
              role="tab"
              aria-selected={filter === tab.key}
              className={`portal-tab${filter === tab.key ? ' is-active' : ''}`}
              onClick={() => setFilter(tab.key)}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {loading ? (
          <div className="portal-loading"><div className="portal-loading-spinner" /></div>
        ) : appointments.length === 0 ? (
          <div className="portal-empty">
            <p>{t('portal.appointments.empty')}</p>
            <Link to="/book-appointment" className="btn btn-primary" style={{ marginTop: '1rem' }}>
              {t('portal.dashboard.bookCta')}
            </Link>
          </div>
        ) : (
          <div className="portal-appt-list">
            {appointments.map((appt) => (
              <article key={appt.id} className="portal-appt-card">
                <div className="portal-appt-main">
                  <h3>{appt.serviceName}</h3>
                  <p className="portal-appt-meta">{appt.locationName}</p>
                  <p className="portal-appt-detail">
                    {t('portal.appointments.date')}:{' '}
                    {appt.scheduledAt ? formatDate(appt.scheduledAt, lang) : appt.preferredAt || '—'}
                  </p>
                  {appt.providerName && (
                    <p className="portal-appt-detail">
                      {t('portal.appointments.provider')}: {appt.providerName}
                    </p>
                  )}
                  {appt.reason && (
                    <p className="portal-appt-detail">
                      {t('portal.appointments.reason')}: {appt.reason}
                    </p>
                  )}
                </div>
                <span className={`portal-status portal-status--${appt.status}`}>
                  {t(`portal.status.${appt.status}`)}
                </span>
              </article>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default PortalAppointments
