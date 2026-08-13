import React from 'react'
import { Link } from 'react-router-dom'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import './Legal.css'

const PrivacyPolicy = () => {
  const { t } = useLanguage()

  const replaceClinic = (text) => text.replace(/\{clinic\}/g, CLINIC.name)

  return (
    <div className="legal-page">
      <PageMeta
        title={t('pages.meta.privacy.title')}
        description={t('pages.meta.privacy.description')}
      />
      <section className="legal-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.meta.privacy.title')}</h1>
          <p className="page-subtitle">{replaceClinic(t('pages.legal.privacySubtitle'))}</p>
        </div>
      </section>

      <section className="legal-content section">
        <div className="container legal-container">
          <p className="legal-updated">{t('pages.legal.lastUpdated')}</p>

          <h2>{t('pages.legal.overview')}</h2>
          <p>{replaceClinic(t('pages.legal.privacyOverview'))}</p>

          <h2>{t('pages.legal.infoCollect')}</h2>
          <p>{t('pages.legal.privacyCollectIntro')}</p>
          <ul>
            <li>{t('pages.legal.privacyCollect1')}</li>
            <li>{t('pages.legal.privacyCollect2')}</li>
            <li>{t('pages.legal.privacyCollect3')}</li>
          </ul>
          <p>{t('pages.legal.privacyNoSensitive')}</p>

          <h2>{t('pages.legal.howWeUse')}</h2>
          <ul>
            <li>{t('pages.legal.privacyUse1')}</li>
            <li>{t('pages.legal.privacyUse2')}</li>
            <li>{t('pages.legal.privacyUse3')}</li>
          </ul>

          <h2>{t('pages.legal.sharing')}</h2>
          <p>{t('pages.legal.privacySharing')}</p>

          <h2>{t('pages.legal.dataSecurity')}</h2>
          <p>{t('pages.legal.privacySecurity')}</p>

          <h2>{t('pages.legal.yourRights')}</h2>
          <p>
            {t('pages.legal.privacyRights')}{' '}
            <a href={`mailto:${CLINIC.email}`}>{CLINIC.email}</a> /{' '}
            <a href={toTelLink(CLINIC.headquarters.phone)}>{CLINIC.headquarters.phone}</a>.
          </p>

          <h2>{t('pages.legal.contact')}</h2>
          <p>
            {t('pages.legal.privacyContact')}{' '}
            <a href={`mailto:${CLINIC.email}`}>{CLINIC.email}</a> /{' '}
            <a href={toTelLink(CLINIC.headquarters.phone)}>{CLINIC.headquarters.phone}</a>.
          </p>

          <div className="legal-actions">
            <Link to="/" className="btn btn-primary">{t('pages.legal.backHome')}</Link>
            <Link to="/contact-us" className="btn btn-outline">{t('common.contactUs')}</Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default PrivacyPolicy
