import React from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { TECHNOLOGY_FEATURES, ORTHOCHAT_FEATURES } from '../data/patientCare'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const Technology = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.technology.title')}
        description={t('pages.meta.technology.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('patientCare.technology.eyebrow')}</span>
          <h1 className="page-title">{t('patientCare.technology.title')}</h1>
          <p className="info-lead">{t('patientCare.technology.lead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-block">
            <h2>{t('patientCare.technology.platformHeading')}</h2>
            <div className="info-card-grid">
              {TECHNOLOGY_FEATURES.map((feature) => (
                <article key={feature.id} className="info-card">
                  <h3>{feature.title[lang] || feature.title.en}</h3>
                  <p>{feature.text[lang] || feature.text.en}</p>
                </article>
              ))}
            </div>
          </div>

          <div id="orthochat" className="info-block info-block--soft">
            <h2>{t('patientCare.technology.orthochatHeading')}</h2>
            <p>{t('patientCare.technology.orthochatLead')}</p>
            <div className="info-card-grid">
              {ORTHOCHAT_FEATURES.map((feature) => (
                <article key={feature.id} className="info-card info-card--flat">
                  <h3>{feature.title[lang] || feature.title.en}</h3>
                  <p>{feature.text[lang] || feature.text.en}</p>
                </article>
              ))}
            </div>
          </div>

          <div className="info-block">
            <p>{t('patientCare.technology.privacyNote')}</p>
            <div className="info-actions">
              <Link to="/telehealth" className="btn btn-primary">
                {t('patientCare.technology.ctaTelehealth')}
              </Link>
              <Link to="/patient-portal" className="btn btn-outline">
                {t('nav.patientPortal')}
              </Link>
              <Link to="/privacy-policy" className="btn btn-outline">
                {t('common.privacyPolicy')}
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Technology
