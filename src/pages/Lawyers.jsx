import React from 'react'
import { Link } from 'react-router-dom'
import { FaBalanceScale, FaArrowRight } from 'react-icons/fa'
import { useLanguage } from '../context/LanguageContext'
import { LA_LAWYERS } from '../data/lawyers'
import { IMAGES } from '../data/images'
import PageMeta from '../components/PageMeta'
import PageHeroMedia from '../components/PageHeroMedia'
import './Lawyers.css'

const Lawyers = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="lawyers-page">
      <PageMeta
        title={t('pages.meta.lawyers.title')}
        description={t('pages.meta.lawyers.description')}
      />

      <section className="lawyers-hero page-hero">
        <PageHeroMedia
          src={IMAGES.home.lawyers.src}
          fallback={IMAGES.home.lawyers.fallback}
          layout="photo"
          objectPosition="center 22%"
        />
        <div className="container page-hero__content">
          <span className="lawyers-eyebrow">{t('pages.lawyers.eyebrow')}</span>
          <h1 className="page-title">{t('pages.lawyers.title')}</h1>
          <p className="page-subtitle">{t('pages.lawyers.lead')}</p>
        </div>
        <Link to="/book-appointment" className="lawyers-hero-book">
          {t('common.bookAppointment')}
          <FaArrowRight aria-hidden="true" />
        </Link>
      </section>

      <section className="lawyers-content section">
        <div className="container">
          <div className="lawyers-intro">
            <div className="lawyers-intro-copy">
              <h2>{t('pages.lawyers.aboutHeading')}</h2>
              <p>{t('pages.lawyers.aboutP1')}</p>
              <p>{t('pages.lawyers.aboutP2')}</p>
            </div>
            <div className="lawyers-intro-card">
              <FaBalanceScale aria-hidden="true" />
              <h3>{t('pages.lawyers.helpTitle')}</h3>
              <p>{t('pages.lawyers.helpText')}</p>
              <Link to="/contact-us" className="btn btn-primary">
                {t('common.contactUs')}
              </Link>
            </div>
          </div>

          <div className="lawyers-directory">
            <div className="lawyers-directory-header">
              <div>
                <h2>{t('pages.lawyers.listHeading')}</h2>
                <p>{t('pages.lawyers.listLead')}</p>
              </div>
              <span className="lawyers-count">
                {LA_LAWYERS.length} {t('pages.lawyers.listed')}
              </span>
            </div>

            <ol className="lawyers-list">
              {LA_LAWYERS.map((lawyer, index) => (
                <li key={lawyer.name} className="lawyer-row">
                  <span className="lawyer-index" aria-hidden="true">
                    {String(index + 1).padStart(2, '0')}
                  </span>
                  <div className="lawyer-main">
                    <h3>{lawyer.name}</h3>
                    <p className="lawyer-focus">
                      {lawyer.focus[lang] || lawyer.focus.en}
                    </p>
                  </div>
                  <span className="lawyer-area">{lawyer.area}</span>
                </li>
              ))}
            </ol>

            <p className="lawyers-disclaimer">{t('pages.lawyers.disclaimer')}</p>
          </div>

          <div className="lawyers-cta">
            <div>
              <h2>{t('pages.lawyers.ctaTitle')}</h2>
              <p>{t('pages.lawyers.ctaText')}</p>
            </div>
            <div className="lawyers-cta-actions">
              <Link to="/book-appointment" className="btn btn-primary">
                {t('common.bookAppointment')}
              </Link>
              <Link to="/services/car-motor-vehicle-accident-care" className="btn btn-outline">
                {t('pages.lawyers.ctaAccident')}
                <FaArrowRight aria-hidden="true" />
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Lawyers
