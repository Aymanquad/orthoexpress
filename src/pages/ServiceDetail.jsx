import React from 'react'
import { useParams, Link } from 'react-router-dom'
import { getServiceDetail } from '../data/serviceDetails'
import { useLanguage } from '../context/LanguageContext'
import NotFound from './NotFound'
import PageMeta from '../components/PageMeta'
import PageHeroMedia from '../components/PageHeroMedia'
import PageBodyMedia from '../components/PageBodyMedia'
import ImageWithFallback from '../components/ImageWithFallback'
import './ServiceDetail.css'

const ServiceDetail = () => {
  const { serviceName } = useParams()
  const { lang, t } = useLanguage()
  const service = getServiceDetail(serviceName, lang)

  if (!service) {
    return <NotFound />
  }

  const heroSrc = service.heroSrc
  const bodySrc = service.placement !== 'photo' ? service.image : null
  const bodyLayout = service.bodyLayout || 'square'

  return (
    <div className="service-detail-page">
      <PageMeta title={service.title} description={service.description} />
      <section className={`service-hero page-hero${heroSrc ? '' : ' page-hero--no-media'}`}>
        {heroSrc && (
          <PageHeroMedia
            src={heroSrc}
            fallback={service.imageFallback}
            layout="photo"
          />
        )}
        <div className="container page-hero__content">
          <Link to="/services" className="back-link">{t('pages.serviceDetail.backLink')}</Link>
          <h1 className="page-title">{service.title}</h1>
          <p className="page-subtitle">{service.description}</p>
        </div>
      </section>

      <section className="service-content">
        <div className="container">
          <div className="service-details">
            {service.overview && (
              <div className={`service-intro${bodySrc ? ' service-intro--with-media' : ''}`}>
                <h2>{t('pages.serviceDetail.about')}</h2>
                <div className="service-intro-body">
                  <p className="service-overview">{service.overview}</p>
                  {bodySrc && (
                    <PageBodyMedia
                      src={bodySrc}
                      fallback={service.imageFallback}
                      alt={service.title}
                      layout={bodyLayout}
                    />
                  )}
                </div>
              </div>
            )}

            {service.featureSections?.map((section) => (
              <div className="service-feature" key={section.title}>
                <div className={`service-feature-media service-feature-media--${section.imageLayout || 'photo'}`}>
                  <ImageWithFallback
                    src={section.image}
                    fallback={section.imageFallback}
                    alt={section.title}
                    loading="lazy"
                  />
                </div>
                <div className="service-feature-content">
                  <h2>{section.title}</h2>
                  <p className="service-feature-copy">{section.overview}</p>
                  {section.highlights && (
                    <ul className="service-feature-list">
                      {section.highlights.map((item) => (
                        <li key={item}>{item}</li>
                      ))}
                    </ul>
                  )}
                  {section.note && (
                    <p className="service-feature-note">{section.note}</p>
                  )}
                </div>
              </div>
            ))}

            <div className="service-section">
              <h2>{t('pages.serviceDetail.conditions')}</h2>
              <ul className="conditions-list">
                {service.conditions.map((condition, index) => (
                  <li key={index}>{condition}</li>
                ))}
              </ul>
            </div>

            <div className="service-section">
              <h2>{t('pages.serviceDetail.treatments')}</h2>
              <ul className="treatments-list">
                {service.treatments.map((treatment, index) => (
                  <li key={index}>{treatment}</li>
                ))}
              </ul>
            </div>

            {service.additionalInfo && (
              <div className="service-section">
                <h2>{t('pages.serviceDetail.whyChoose')}</h2>
                <p className="service-additional-info">{service.additionalInfo}</p>
              </div>
            )}

            <div className="service-cta">
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

export default ServiceDetail
