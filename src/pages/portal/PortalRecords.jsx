import React, { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import {
  FiAlertCircle,
  FiArrowLeft,
  FiCalendar,
  FiCheckCircle,
  FiClipboard,
  FiClock,
  FiDroplet,
  FiEdit3,
  FiHeart,
  FiMapPin,
  FiMessageCircle,
  FiPhone,
  FiShield,
  FiUser,
} from 'react-icons/fi'
import PageMeta from '../../components/PageMeta'
import { useLanguage } from '../../context/LanguageContext'
import { useAuth } from '../../context/AuthContext'
import { recordsApi } from '../../api/client'
import './Portal.css'

const emptyContact = {
  address: '',
  city: '',
  state: '',
  country: '',
  zip: '',
  emergencyName: '',
  emergencyPhone: '',
  emergencyRelationship: '',
}

const RX_FILTERS = ['ALL', 'ACTIVE', 'COMPLETED', 'DISCONTINUED']

function RxStatus({ status, t }) {
  const key = String(status || '').toUpperCase()
  const labels = {
    ACTIVE: t('portal.records.statusActive'),
    COMPLETED: t('portal.records.statusCompleted'),
    DISCONTINUED: t('portal.records.statusDiscontinued'),
    STOPPED: t('portal.records.statusDiscontinued'),
  }
  return (
    <span className={`portal-rx-status portal-rx-status--${key}`}>
      {labels[key] || key.replaceAll('_', ' ')}
    </span>
  )
}

function InfoTile({ icon: Icon, label, value, tone, wide }) {
  return (
    <div
      className={[
        'portal-records-tile',
        tone ? `portal-records-tile--${tone}` : '',
        wide ? 'portal-records-tile--wide' : '',
      ]
        .filter(Boolean)
        .join(' ')}
    >
      <span className="portal-records-tile-icon" aria-hidden="true">
        <Icon />
      </span>
      <div>
        <span className="portal-records-tile-label">{label}</span>
        <strong className="portal-records-tile-value">{value || '—'}</strong>
      </div>
    </div>
  )
}

function RecordsSkeleton() {
  return (
    <div className="portal-records-skeleton" aria-hidden="true">
      <div className="portal-records-skeleton-stats">
        <span /><span /><span />
      </div>
      <div className="portal-records-skeleton-grid">
        <span className="portal-records-skeleton-panel" />
        <span className="portal-records-skeleton-panel" />
      </div>
    </div>
  )
}

function formatUpdated(iso, lang) {
  if (!iso) return null
  return new Date(iso).toLocaleString(lang === 'es' ? 'es-US' : 'en-US', {
    dateStyle: 'medium',
    timeStyle: 'short',
  })
}

export default function PortalRecords() {
  const { t, lang } = useLanguage()
  const { patient } = useAuth()
  const [data, setData] = useState({ prescriptions: [], demographics: null, patient: null })
  const [contact, setContact] = useState(emptyContact)
  const [editing, setEditing] = useState(false)
  const [rxFilter, setRxFilter] = useState('ALL')
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const load = () => {
    setLoading(true)
    setError('')
    return Promise.all([recordsApi.prescriptions(), recordsApi.demographics()])
      .then(([rx, demo]) => {
        const demographics = demo.demographics
        setData({
          prescriptions: rx.prescriptions || [],
          demographics,
          patient: demo.patient,
        })
        setContact({
          address: demographics?.address || '',
          city: demographics?.city || '',
          state: demographics?.state || '',
          country: demographics?.country || '',
          zip: demographics?.zip || '',
          emergencyName: demographics?.emergencyName || '',
          emergencyPhone: demographics?.emergencyPhone || '',
          emergencyRelationship: demographics?.emergencyRelationship || '',
        })
      })
      .catch((err) => setError(err.message || t('portal.errors.generic')))
      .finally(() => setLoading(false))
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const onSaveContact = async (e) => {
    e.preventDefault()
    setSaving(true)
    setError('')
    setSuccess('')
    try {
      const res = await recordsApi.updateDemographicsContact(contact)
      setData((prev) => ({ ...prev, demographics: res.demographics, patient: res.patient }))
      setEditing(false)
      setSuccess(t('portal.records.contactSaved'))
    } catch (err) {
      setError(err.message || t('portal.errors.generic'))
    } finally {
      setSaving(false)
    }
  }

  const d = data.demographics
  const displayName =
    [patient?.firstName, patient?.lastName].filter(Boolean).join(' ') ||
    [data.patient?.firstName, data.patient?.lastName].filter(Boolean).join(' ') ||
    t('portal.dashboard.welcomeGuest')

  const activeRx = useMemo(
    () => data.prescriptions.filter((rx) => rx.status === 'ACTIVE').length,
    [data.prescriptions]
  )

  const filteredRx = useMemo(() => {
    if (rxFilter === 'ALL') return data.prescriptions
    if (rxFilter === 'DISCONTINUED') {
      return data.prescriptions.filter(
        (rx) => rx.status === 'DISCONTINUED' || rx.status === 'STOPPED'
      )
    }
    return data.prescriptions.filter((rx) => rx.status === rxFilter)
  }, [data.prescriptions, rxFilter])

  const addressLine = d
    ? [d.address, d.city, d.state, d.zip, d.country].filter(Boolean).join(', ')
    : ''

  const emergencyLine = d
    ? [d.emergencyName, d.emergencyRelationship, d.emergencyPhone].filter(Boolean).join(' · ')
    : ''

  const insuranceLine = d
    ? [d.insuranceProvider, d.insurancePolicyNumber].filter(Boolean).join(' · ')
    : ''

  const lastUpdated = formatUpdated(d?.updatedAt, lang)

  const resetContact = () => {
    setEditing(false)
    setContact({
      address: d?.address || '',
      city: d?.city || '',
      state: d?.state || '',
      country: d?.country || '',
      zip: d?.zip || '',
      emergencyName: d?.emergencyName || '',
      emergencyPhone: d?.emergencyPhone || '',
      emergencyRelationship: d?.emergencyRelationship || '',
    })
  }

  return (
    <div className="portal-page portal-records-page">
      <PageMeta title={t('portal.records.title')} />

      <section className="portal-records-hero">
        <div className="portal-records-hero-bg" aria-hidden="true" />
        <div className="container">
          <Link to="/portal" className="portal-records-back">
            <FiArrowLeft aria-hidden="true" />
            {t('portal.goToDashboard')}
          </Link>

          <div className="portal-records-hero-grid">
            <div className="portal-records-hero-copy">
              <p className="portal-records-kicker">{t('portal.myPortal')}</p>
              <h1>
                {t('portal.records.heroTitle').replace(
                  '{name}',
                  patient?.firstName || displayName.split(' ')[0]
                )}
              </h1>
              <p className="portal-records-lead">{t('portal.records.lead')}</p>
              {lastUpdated ? (
                <p className="portal-records-updated">
                  <FiClock aria-hidden="true" />
                  {t('portal.records.lastUpdated')}: {lastUpdated}
                </p>
              ) : null}
            </div>

            <aside className="portal-records-snapshot" aria-label={t('portal.records.snapshotLabel')}>
              <div className="portal-records-snapshot-head">
                <span className="portal-records-patient-avatar" aria-hidden="true">
                  {(displayName[0] || 'P').toUpperCase()}
                </span>
                <div>
                  <strong>{displayName}</strong>
                  <span>{patient?.phone || data.patient?.phone}</span>
                </div>
              </div>
              <div className="portal-records-snapshot-metrics">
                <div className="portal-records-metric portal-records-metric--rx">
                  <strong>{activeRx}</strong>
                  <span>{t('portal.records.activeRx')}</span>
                </div>
                <div className={`portal-records-metric${d?.allergies ? ' portal-records-metric--alert' : ''}`}>
                  <strong>{d?.allergies ? '!' : '—'}</strong>
                  <span>{t('portal.records.allergies')}</span>
                </div>
                <div className={`portal-records-metric${d?.insuranceProvider ? ' portal-records-metric--ok' : ''}`}>
                  <strong>{d?.insuranceProvider ? '✓' : '—'}</strong>
                  <span>{t('portal.records.insurance')}</span>
                </div>
              </div>
            </aside>
          </div>
        </div>
      </section>

      <div className="container portal-records-body portal-records-body-enter">
        <div className="portal-records-toolbar">
          <div className="portal-records-quick">
            <Link to="/book-appointment" className="portal-records-quick-btn portal-records-quick-btn--primary">
              {t('portal.dashboard.bookCta')}
            </Link>
            <Link to="/contact-us" className="portal-records-quick-btn">
              <FiMessageCircle aria-hidden="true" />
              {t('portal.dashboard.contactClinic')}
            </Link>
            {!editing && (d || data.patient) ? (
              <button type="button" className="portal-records-quick-btn" onClick={() => setEditing(true)}>
                <FiEdit3 aria-hidden="true" />
                {t('portal.records.editContact')}
              </button>
            ) : null}
          </div>
        </div>

        {error ? (
          <div className="portal-records-alert portal-records-alert--error" role="alert">
            <FiAlertCircle aria-hidden="true" />
            {error}
          </div>
        ) : null}
        {success ? (
          <div className="portal-records-alert portal-records-alert--success" role="status">
            <FiCheckCircle aria-hidden="true" />
            {success}
          </div>
        ) : null}

        {d?.allergies ? (
          <div className="portal-records-allergy-banner" role="note">
            <FiAlertCircle aria-hidden="true" />
            <div>
              <strong>{t('portal.records.allergyAlert')}</strong>
              <p>{d.allergies}</p>
            </div>
          </div>
        ) : null}

        {loading ? (
          <RecordsSkeleton />
        ) : (
          <div className="portal-records-grid">
            <section className="portal-records-card" id="portal-records-profile">
              <header className="portal-records-card-head">
                <div className="portal-records-card-title">
                  <span className="portal-records-card-icon" aria-hidden="true">
                    <FiUser />
                  </span>
                  <div>
                    <h2>{t('portal.records.demographics')}</h2>
                    <p>{t('portal.records.demographicsHint')}</p>
                  </div>
                </div>
              </header>

              {!d && !editing ? (
                <div className="portal-records-empty">
                  <span className="portal-records-empty-icon" aria-hidden="true">
                    <FiUser />
                  </span>
                  <p>{t('portal.records.noDemo')}</p>
                  <button type="button" className="btn btn-primary btn-sm" onClick={() => setEditing(true)}>
                    {t('portal.records.addContact')}
                  </button>
                </div>
              ) : editing ? (
                <form className="portal-records-form" onSubmit={onSaveContact}>
                  <p className="portal-records-form-hint">{t('portal.records.contactEditHint')}</p>
                  <fieldset className="portal-records-fieldset">
                    <legend>{t('portal.records.sectionContact')}</legend>
                    <div className="portal-field">
                      <label>{t('portal.records.address')}</label>
                      <input
                        value={contact.address}
                        onChange={(e) => setContact((f) => ({ ...f, address: e.target.value }))}
                      />
                    </div>
                    <div className="portal-records-form-row">
                      <div className="portal-field">
                        <label>City</label>
                        <input
                          value={contact.city}
                          onChange={(e) => setContact((f) => ({ ...f, city: e.target.value }))}
                        />
                      </div>
                      <div className="portal-field">
                        <label>State</label>
                        <input
                          value={contact.state}
                          onChange={(e) => setContact((f) => ({ ...f, state: e.target.value }))}
                        />
                      </div>
                    </div>
                    <div className="portal-records-form-row">
                      <div className="portal-field">
                        <label>ZIP</label>
                        <input
                          value={contact.zip}
                          onChange={(e) => setContact((f) => ({ ...f, zip: e.target.value }))}
                        />
                      </div>
                      <div className="portal-field">
                        <label>{t('portal.records.country')}</label>
                        <input
                          value={contact.country}
                          onChange={(e) => setContact((f) => ({ ...f, country: e.target.value }))}
                        />
                      </div>
                    </div>
                  </fieldset>
                  <fieldset className="portal-records-fieldset">
                    <legend>{t('portal.records.sectionEmergency')}</legend>
                    <div className="portal-records-form-row">
                      <div className="portal-field">
                        <label>{t('portal.records.emergency')}</label>
                        <input
                          value={contact.emergencyName}
                          onChange={(e) => setContact((f) => ({ ...f, emergencyName: e.target.value }))}
                        />
                      </div>
                      <div className="portal-field">
                        <label>{t('portal.records.emergencyPhone')}</label>
                        <input
                          value={contact.emergencyPhone}
                          onChange={(e) => setContact((f) => ({ ...f, emergencyPhone: e.target.value }))}
                        />
                      </div>
                    </div>
                    <div className="portal-field">
                      <label>{t('portal.records.emergencyRelationship')}</label>
                      <input
                        value={contact.emergencyRelationship}
                        onChange={(e) =>
                          setContact((f) => ({ ...f, emergencyRelationship: e.target.value }))
                        }
                      />
                    </div>
                  </fieldset>
                  <div className="portal-records-form-actions">
                    <button type="submit" className="btn btn-primary" disabled={saving}>
                      {saving ? t('portal.records.saving') : t('portal.records.saveContact')}
                    </button>
                    <button type="button" className="btn btn-outline" onClick={resetContact}>
                      {t('portal.records.cancel')}
                    </button>
                  </div>
                </form>
              ) : (
                <>
                  <div className="portal-records-section">
                    <h3>{t('portal.records.sectionIdentity')}</h3>
                    <div className="portal-records-tiles">
                      <InfoTile icon={FiCalendar} label={t('portal.records.dob')} value={d.dateOfBirth} />
                      <InfoTile icon={FiUser} label={t('portal.records.sex')} value={d.sex} />
                      {d.bloodType ? (
                        <InfoTile icon={FiDroplet} label={t('portal.records.bloodType')} value={d.bloodType} />
                      ) : null}
                    </div>
                  </div>

                  <div className="portal-records-section">
                    <h3>{t('portal.records.sectionContact')}</h3>
                    <div className="portal-records-tiles">
                      <InfoTile icon={FiMapPin} label={t('portal.records.address')} value={addressLine} wide />
                      <InfoTile icon={FiPhone} label={t('portal.records.emergency')} value={emergencyLine} wide />
                    </div>
                  </div>

                  {d.insuranceProvider ? (
                    <div className="portal-records-section">
                      <h3>{t('portal.records.sectionCoverage')}</h3>
                      <div className="portal-records-tiles">
                        <InfoTile icon={FiShield} label={t('portal.records.insurance')} value={insuranceLine} wide />
                      </div>
                    </div>
                  ) : null}

                  <div className="portal-records-section">
                    <h3>{t('portal.records.sectionClinical')}</h3>
                    <div className="portal-records-tiles">
                      <InfoTile
                        icon={FiHeart}
                        label={t('portal.records.allergies')}
                        value={d.allergies}
                        tone={d.allergies ? 'warn' : undefined}
                      />
                      <InfoTile icon={FiClipboard} label={t('portal.records.conditions')} value={d.conditions} />
                    </div>
                  </div>

                  <p className="portal-records-footnote">{t('portal.records.clinicalReadOnly')}</p>
                </>
              )}
            </section>

            <section className="portal-records-card" id="portal-records-meds">
              <header className="portal-records-card-head">
                <div className="portal-records-card-title">
                  <span className="portal-records-card-icon portal-records-card-icon--rx" aria-hidden="true">
                    <FiClipboard />
                  </span>
                  <div>
                    <h2>{t('portal.records.prescriptions')}</h2>
                    <p>{t('portal.records.prescriptionsHint')}</p>
                  </div>
                </div>
              </header>

              {data.prescriptions.length > 0 ? (
                <div className="portal-rx-filters" role="tablist" aria-label={t('portal.records.filterLabel')}>
                  {RX_FILTERS.map((key) => {
                    const count =
                      key === 'ALL'
                        ? data.prescriptions.length
                        : key === 'DISCONTINUED'
                          ? data.prescriptions.filter(
                              (rx) => rx.status === 'DISCONTINUED' || rx.status === 'STOPPED'
                            ).length
                          : data.prescriptions.filter((rx) => rx.status === key).length
                    const labelKey = {
                      ALL: 'filterAll',
                      ACTIVE: 'statusActive',
                      COMPLETED: 'statusCompleted',
                      DISCONTINUED: 'statusDiscontinued',
                    }[key]
                    return (
                      <button
                        key={key}
                        type="button"
                        role="tab"
                        aria-selected={rxFilter === key}
                        className={`portal-rx-filter${rxFilter === key ? ' is-active' : ''}`}
                        onClick={() => setRxFilter(key)}
                      >
                        {t(`portal.records.${labelKey}`)}
                        <em>{count}</em>
                      </button>
                    )
                  })}
                </div>
              ) : null}

              {data.prescriptions.length === 0 ? (
                <div className="portal-records-empty">
                  <span className="portal-records-empty-icon" aria-hidden="true">
                    <FiClipboard />
                  </span>
                  <p>{t('portal.records.noRx')}</p>
                </div>
              ) : filteredRx.length === 0 ? (
                <div className="portal-records-empty portal-records-empty--compact">
                  <p>{t('portal.records.noRxFilter')}</p>
                </div>
              ) : (
                <div className="portal-rx-list portal-rx-list--timeline">
                  {filteredRx.map((rx, index) => (
                    <article
                      key={rx.id}
                      className={`portal-rx-card portal-rx-card--${String(rx.status).toLowerCase()}`}
                      style={{ animationDelay: `${index * 60}ms` }}
                    >
                      <div className="portal-rx-card-rail" aria-hidden="true">
                        <span className="portal-rx-card-dot" />
                      </div>
                      <div className="portal-rx-card-content">
                        <div className="portal-rx-card-top">
                          <h3>{rx.medication}</h3>
                          <RxStatus status={rx.status} t={t} />
                        </div>
                        <p className="portal-rx-dose">{rx.dosage}</p>
                        {rx.frequency ? <p className="portal-rx-meta">{rx.frequency}</p> : null}
                        {rx.instructions ? (
                          <p className="portal-rx-instructions">{rx.instructions}</p>
                        ) : null}
                        {rx.prescribedBy ? (
                          <p className="portal-rx-provider">
                            {t('portal.appointments.provider')}: {rx.prescribedBy}
                          </p>
                        ) : null}
                      </div>
                    </article>
                  ))}
                </div>
              )}
            </section>
          </div>
        )}
      </div>
    </div>
  )
}
