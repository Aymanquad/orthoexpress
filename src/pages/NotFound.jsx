import React from 'react'
import { Link } from 'react-router-dom'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import './NotFound.css'

const NotFound = () => {
  const { t } = useLanguage()

  return (
    <div className="not-found-page">
      <PageMeta
        title={t('pages.meta.notFound.title')}
        description={t('pages.meta.notFound.description')}
      />
      <section className="not-found-content section">
        <div className="container not-found-container">
          <span className="not-found-code">404</span>
          <h1 className="not-found-title">{t('pages.notFound.title')}</h1>
          <p className="not-found-text">{t('pages.notFound.text')}</p>
          <div className="not-found-actions">
            <Link to="/" className="btn btn-primary">{t('pages.notFound.goHome')}</Link>
            <Link to="/book-appointment" className="btn btn-outline">{t('pages.notFound.bookAppointment')}</Link>
            <a href={toTelLink(CLINIC.headquarters.phone)} className="btn btn-outline">
              {t('pages.notFound.call')} {CLINIC.headquarters.phone}
            </a>
          </div>
          <div className="not-found-links">
            <Link to="/locations">{t('nav.locations')}</Link>
            <Link to="/contact-us">{t('nav.contact')}</Link>
            <Link to="/services">{t('nav.services')}</Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default NotFound
