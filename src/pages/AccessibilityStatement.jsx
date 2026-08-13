import React from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { useLanguage } from '../context/LanguageContext'
import './Legal.css'

const AccessibilityStatement = () => {
  const { t } = useLanguage()

  return (
    <div className="legal-page">
      <PageMeta
        title={t('pages.meta.accessibility.title')}
        description={t('pages.meta.accessibility.description')}
      />
      <section className="legal-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.info.accessibilityTitle')}</h1>
          <p className="page-subtitle">{t('pages.info.accessibilityLead')}</p>
        </div>
      </section>
      <section className="legal-content section">
        <div className="container legal-container">
          <h2>{t('pages.info.accessibilityCommitment')}</h2>
          <p>{t('pages.info.accessibilityLead')}</p>
          <h2>{t('pages.info.accessibilityTools')}</h2>
          <p>{t('pages.info.accessibilityToolsText')}</p>
          <h2>{t('pages.info.accessibilityContact')}</h2>
          <p>{t('pages.info.accessibilityContactText')}</p>
          <p>
            <Link to="/contact-us">{t('common.contactUs')}</Link>
          </p>
        </div>
      </section>
    </div>
  )
}

export default AccessibilityStatement
