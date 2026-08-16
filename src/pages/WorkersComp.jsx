import React from 'react'
import { Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaArrowRight } from 'react-icons/fa'
import { LOCATIONS } from '../data'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import { IMAGES } from '../data/images'
import PageHeroMedia from '../components/PageHeroMedia'
import './WorkersComp.css'

const WorkersComp = () => {
  const { t } = useLanguage()

  return (
    <div className="workers-comp-page">
      <PageMeta
        title={t('pages.meta.workersComp.title')}
        description={t('pages.meta.workersComp.description')}
      />
      <section className="workers-comp-hero page-hero">
        <PageHeroMedia
          src={IMAGES.workersComp.hero.src}
          fallback={IMAGES.workersComp.hero.fallback}
          layout="photo"
          objectPosition={IMAGES.workersComp.hero.objectPosition || 'center 40%'}
        />
        <div className="container page-hero__content">
          <span className="workers-comp-eyebrow">{t('pages.workersComp.eyebrow')}</span>
          <h1 className="page-title">{t('pages.workersComp.title')}</h1>
          <p className="page-subtitle">{t('pages.workersComp.lead')}</p>
        </div>
        <Link to="/book-appointment" className="workers-comp-hero-book">
          {t('common.bookAppointment')}
          <FaArrowRight aria-hidden="true" />
        </Link>
      </section>

      <section className="workers-comp-content section">
        <div className="workers-comp-container">
          <div className="workers-comp-main">
            <div className="workers-comp-intro">
              <p className="intro-text">{t('pages.workersComp.intro1')}</p>
              <p className="intro-text highlight">{t('pages.workersComp.intro2')}</p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">{t('pages.workersComp.section1')}</h3>
              <p className="section-text">{t('pages.workersComp.section1Text')}</p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">{t('pages.workersComp.section2')}</h3>
              <p className="section-text">{t('pages.workersComp.section2Text')}</p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">{t('pages.workersComp.section3')}</h3>
              <p className="section-text">{t('pages.workersComp.section3Text')}</p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">{t('pages.workersComp.section4')}</h3>
              <p className="section-text">
                {t('pages.workersComp.section4Text')}
              </p>
            </div>
          </div>

          <aside className="workers-comp-sidebar">
            <div className="locations-card">
              <h4 className="locations-card-title">{t('pages.workersComp.locationsTitle')}</h4>
              <ul className="locations-list">
                {LOCATIONS.map((location) => (
                  <li key={location.slug}>
                    <Link to={`/locations/${location.slug}`} className="location-item">
                      <FaMapMarkerAlt className="location-icon" />
                      <span className="location-name">{location.name}</span>
                      <FaArrowRight className="location-arrow" />
                    </Link>
                  </li>
                ))}
              </ul>
              <Link to="/book-appointment" className="workers-comp-book-link">
                {t('pages.workersComp.bookLink')}
              </Link>
            </div>
          </aside>
        </div>
      </section>
    </div>
  )
}

export default WorkersComp
