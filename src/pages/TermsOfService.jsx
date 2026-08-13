import React from 'react'
import { Link } from 'react-router-dom'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import './Legal.css'

const TermsOfService = () => {
  const { t } = useLanguage()

  const replaceClinic = (text) => text.replace(/\{clinic\}/g, CLINIC.name)

  return (
    <div className="legal-page">
      <PageMeta
        title={t('pages.meta.terms.title')}
        description={t('pages.meta.terms.description')}
      />
      <section className="legal-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.meta.terms.title')}</h1>
          <p className="page-subtitle">{replaceClinic(t('pages.legal.termsSubtitle'))}</p>
        </div>
      </section>

      <section className="legal-content section">
        <div className="container legal-container">
          <p className="legal-updated">{t('pages.legal.lastUpdated')}</p>

          <h2>{t('pages.legal.acceptance')}</h2>
          <p>{replaceClinic(t('pages.legal.termsAccept'))}</p>

          <h2>{t('pages.legal.websitePurpose')}</h2>
          <p>{t('pages.legal.termsPurpose')}</p>

          <h2>{t('pages.legal.noEmergency')}</h2>
          <p>{t('pages.legal.termsEmergency')}</p>

          <h2>{t('pages.legal.appointments')}</h2>
          <p>{t('pages.legal.termsAppointments')}</p>

          <h2>{t('pages.legal.accuracy')}</h2>
          <p>{replaceClinic(t('pages.legal.termsAccuracy'))}</p>

          <h2>{t('pages.legal.limitation')}</h2>
          <p>{replaceClinic(t('pages.legal.termsLiability'))}</p>

          <h2>{t('pages.legal.changes')}</h2>
          <p>{t('pages.legal.termsChanges')}</p>

          <h2>{t('pages.legal.contact')}</h2>
          <p>
            {t('pages.legal.termsContact')}{' '}
            <a href={`mailto:${CLINIC.email}`}>{CLINIC.email}</a> /{' '}
            <a href={toTelLink(CLINIC.headquarters.phone)}>{CLINIC.headquarters.phone}</a>.
          </p>

          <div className="legal-actions">
            <Link to="/" className="btn btn-primary">{t('pages.legal.backHome')}</Link>
            <Link to="/privacy-policy" className="btn btn-outline">{t('footer.privacy')}</Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default TermsOfService
