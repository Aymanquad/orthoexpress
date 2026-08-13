import React from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { CLINIC } from '../data'
import { CAREERS } from '../data/content'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const Careers = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.careers.title')}
        description={t('pages.meta.careers.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('pages.info.careersEyebrow')}</span>
          <h1 className="page-title">{t('pages.info.careersTitle')}</h1>
          <p className="info-lead">{t('pages.info.careersLead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-card-grid">
            {CAREERS.map((job) => (
              <article key={job.id} className="info-card">
                <div className="info-card-meta">
                  <span>{job.type[lang] || job.type.en}</span>
                  <span>{job.location[lang] || job.location.en}</span>
                </div>
                <h2>{job.title[lang] || job.title.en}</h2>
                <p>{job.summary[lang] || job.summary.en}</p>
                <a
                  className="info-card-link"
                  href={`mailto:${CLINIC.email}?subject=${encodeURIComponent(`${t('pages.info.applyNow')}: ${job.title[lang] || job.title.en}`)}`}
                >
                  {t('pages.info.applyNow')} →
                </a>
              </article>
            ))}
          </div>

          <div className="info-block info-block--soft">
            <h2>{t('pages.info.careersTitle')}</h2>
            <p>{t('pages.info.careersLead')}</p>
            <div className="info-actions">
              <a href={`mailto:${CLINIC.email}`} className="btn btn-primary">
                {CLINIC.email}
              </a>
              <Link to="/contact-us" className="btn btn-outline">
                {t('common.contactUs')}
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Careers
