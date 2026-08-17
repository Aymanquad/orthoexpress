import React from 'react'
import { Link } from 'react-router-dom'
import { FaSignInAlt } from 'react-icons/fa'
import PageMeta from '../components/PageMeta'
import { PORTAL_FEATURES } from '../data/patientCare'
import { PORTAL_DASHBOARD_PATH, PORTAL_LOGIN_PATH } from '../config/portal'
import { useLanguage } from '../context/LanguageContext'
import { useAuth } from '../context/AuthContext'
import './InfoPages.css'

const PatientPortal = () => {
  const { t, lang } = useLanguage()
  const { isAuthenticated } = useAuth()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.patientPortal.title')}
        description={t('pages.meta.patientPortal.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('patientCare.portal.eyebrow')}</span>
          <h1 className="page-title">{t('patientCare.portal.title')}</h1>
          <p className="info-lead">{t('patientCare.portal.lead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-block info-block--soft info-portal-signin">
            <h2>{t('patientCare.portal.signIn')}</h2>
            <p>{t('patientCare.portal.signInHelp')}</p>
            <Link
              to={isAuthenticated ? PORTAL_DASHBOARD_PATH : PORTAL_LOGIN_PATH}
              className="btn btn-primary"
            >
              <FaSignInAlt aria-hidden="true" />{' '}
              {isAuthenticated ? t('portal.goToDashboard') : t('portal.signInWithPhone')}
            </Link>
            <p className="info-portal-note">{t('patientCare.portal.demoNote')}</p>
          </div>

          <div className="info-block">
            <h2>{t('patientCare.portal.featuresHeading')}</h2>
            <div className="info-card-grid">
              {PORTAL_FEATURES.map((feature) => {
                const link =
                  feature.id === 'appointments'
                    ? isAuthenticated
                      ? '/portal/appointments'
                      : PORTAL_LOGIN_PATH
                    : feature.link
                return (
                  <article key={feature.id} className="info-card">
                    <h3>{feature.title[lang] || feature.title.en}</h3>
                    <p>{feature.text[lang] || feature.text.en}</p>
                    <Link to={link} className="info-card-link">
                      {t('common.learnMore')} →
                    </Link>
                  </article>
                )
              })}
            </div>
          </div>

          <div className="info-block info-block--soft">
            <h2>{t('patientCare.portal.noPortalTitle')}</h2>
            <p>{t('patientCare.portal.noPortalText')}</p>
            <div className="info-actions">
              <Link to="/contact-us" className="btn btn-primary">
                {t('common.contactUs')}
              </Link>
              <Link to="/book-appointment" className="btn btn-outline">
                {t('common.bookAppointment')}
              </Link>
              <Link to="/payment" className="btn btn-outline">
                {t('nav.payment')}
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default PatientPortal
