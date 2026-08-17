import React from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { AFTER_VISIT_STEPS } from '../data/patientCare'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const AfterVisit = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.afterVisit.title')}
        description={t('pages.meta.afterVisit.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('patientCare.afterVisit.eyebrow')}</span>
          <h1 className="page-title">{t('patientCare.afterVisit.title')}</h1>
          <p className="info-lead">{t('patientCare.afterVisit.lead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-block">
            <h2>{t('patientCare.afterVisit.stepsHeading')}</h2>
            <div className="info-card-grid info-card-grid--after-visit">
              {AFTER_VISIT_STEPS.map((step) => (
                <article key={step.id} className="info-card info-card--step">
                  <h3>{step.title[lang] || step.title.en}</h3>
                  <p>{step.text[lang] || step.text.en}</p>
                  <Link to={step.link} className="info-card-link">
                    {step.linkLabel[lang] || step.linkLabel.en} →
                  </Link>
                </article>
              ))}
            </div>
          </div>

          <div className="info-actions">
            <Link to="/contact-us" className="btn btn-primary">
              {t('patientCare.afterVisit.ctaContact')}
            </Link>
            <Link to="/faqs" className="btn btn-outline">
              {t('nav.faqs')}
            </Link>
            <Link to="/portal/login" className="btn btn-outline">
              {t('portal.signIn')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default AfterVisit
