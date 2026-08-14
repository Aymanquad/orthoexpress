import React from 'react'
import { Link } from 'react-router-dom'
import { FaArrowRight } from 'react-icons/fa'
import {
  PRIMARY_SERVICE_CARDS,
  SPECIALTY_SERVICE_CARDS,
  WORKERS_COMP_SERVICE,
  getServicePath,
  getServiceLabel,
  getServiceCardSummary,
} from '../data/services'
import { getServiceImage } from '../data/images'
import { useLanguage } from '../context/LanguageContext'
import ImageWithFallback from '../components/ImageWithFallback'
import PageMeta from '../components/PageMeta'
import './Services.css'

function ServiceCard({ service }) {
  const { lang } = useLanguage()
  const img = getServiceImage(service.slug)

  return (
    <Link to={getServicePath(service)} className="services-card">
      <div className="services-card-thumb">
        <ImageWithFallback
          src={img.src}
          fallback={img.fallback}
          alt=""
          className="services-card-img"
        />
      </div>
      <div className="services-card-body">
        <span className="services-card-arrow" aria-hidden="true">
          <FaArrowRight />
        </span>
        <h2 className="services-card-title">{getServiceLabel(service, lang)}</h2>
        <p className="services-card-summary">{getServiceCardSummary(service, lang)}</p>
      </div>
    </Link>
  )
}

const Services = () => {
  const { t } = useLanguage()

  return (
    <div className="services-page">
      <PageMeta
        title={t('pages.meta.services.title')}
        description={t('pages.meta.services.description')}
      />

      <section className="services-hero section">
        <div className="container services-hero-inner">
          <span className="services-eyebrow">{t('pages.services.eyebrow')}</span>
          <h1 className="page-title">{t('pages.services.title')}</h1>
          <p className="services-intro">{t('pages.services.intro')}</p>
        </div>
      </section>

      <section className="services-grid-section section">
        <div className="container">
          <div className="services-section-block">
            <h2 className="services-section-heading">{t('pages.services.coreHeading')}</h2>
            <p className="services-section-lead">{t('pages.services.coreLead')}</p>
            <div className="services-grid">
              {PRIMARY_SERVICE_CARDS.map((service) => (
                <ServiceCard key={getServicePath(service)} service={service} />
              ))}
            </div>
          </div>

          <div className="services-section-block">
            <h2 className="services-section-heading">{t('pages.services.specialtyHeading')}</h2>
            <p className="services-section-lead">{t('pages.services.specialtyLead')}</p>
            <div className="services-grid">
              {SPECIALTY_SERVICE_CARDS.map((service) => (
                <ServiceCard key={getServicePath(service)} service={service} />
              ))}
            </div>
          </div>

          <div className="services-section-block services-section-block--compact">
            <h2 className="services-section-heading">{t('pages.services.workersHeading')}</h2>
            <div className="services-grid services-grid--single">
              <ServiceCard service={WORKERS_COMP_SERVICE} />
            </div>
          </div>

          <div className="services-cta">
            <p>{t('pages.services.ctaPrompt')}</p>
            <div className="services-cta-actions">
              <Link to="/book-appointment" className="btn btn-primary">
                {t('common.bookAppointment')}
              </Link>
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

export default Services
