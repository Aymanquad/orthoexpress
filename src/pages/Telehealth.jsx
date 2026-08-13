import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaVideo } from 'react-icons/fa'
import PageMeta from '../components/PageMeta'
import { CLINIC } from '../data'
import { TELEHEALTH_WHEN, TELEHEALTH_STEPS } from '../data/patientCare'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const Telehealth = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.telehealth.title')}
        description={t('pages.meta.telehealth.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('patientCare.telehealth.eyebrow')}</span>
          <h1 className="page-title">{t('patientCare.telehealth.title')}</h1>
          <p className="info-lead">{t('patientCare.telehealth.lead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-block">
            <h2>{t('patientCare.telehealth.whenHeading')}</h2>
            <div className="info-card-grid">
              {TELEHEALTH_WHEN.map((item) => (
                <article key={item.id} className="info-card">
                  <h3>{item.title[lang] || item.title.en}</h3>
                  <p>{item.text[lang] || item.text.en}</p>
                </article>
              ))}
            </div>
          </div>

          <div className="info-block">
            <h2>{t('patientCare.telehealth.stepsHeading')}</h2>
            <ol className="info-steps">
              {TELEHEALTH_STEPS.map((step, index) => (
                <li key={step.id} className="info-step">
                  <span className="info-step-num">{index + 1}</span>
                  <div>
                    <h3>{step.title[lang] || step.title.en}</h3>
                    <p>{step.text[lang] || step.text.en}</p>
                  </div>
                </li>
              ))}
            </ol>
          </div>

          <div className="info-block info-block--soft">
            <p>{t('patientCare.telehealth.walkInNote')}</p>
            <div className="info-actions">
              <Link to="/book-appointment" className="btn btn-primary">
                <FaVideo aria-hidden="true" /> {t('patientCare.telehealth.ctaBook')}
              </Link>
              <a href={toTelLink(CLINIC.headquarters.phone)} className="btn btn-outline">
                <FaPhone aria-hidden="true" /> {t('common.call')}
              </a>
              <Link to="/after-your-visit" className="btn btn-outline">
                {t('patientCare.telehealth.ctaAfterVisit')}
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Telehealth
