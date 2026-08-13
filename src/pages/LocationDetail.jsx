import React, { useEffect, useRef } from 'react'
import { useParams, Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaPhone, FaClock, FaCheckCircle, FaStethoscope, FaHospital, FaDirections } from 'react-icons/fa'
import { toTelLink, getMapsDirectionsUrl } from '../data/utils'
import { getLocalizedLocation } from '../i18n/locations'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import PageHeroMedia from '../components/PageHeroMedia'
import NotFound from './NotFound'
import './LocationDetail.css'

const LocationDetail = () => {
  const { locationName } = useParams()
  const { t, lang } = useLanguage()
  const location = getLocalizedLocation(locationName, lang)

  const sectionRefs = useRef([])

  useEffect(() => {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px',
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in')
        }
      })
    }, observerOptions)

    sectionRefs.current.forEach((section) => {
      if (section) observer.observe(section)
    })

    return () => {
      sectionRefs.current.forEach((section) => {
        if (section) observer.unobserve(section)
      })
    }
  }, [])

  if (!location) {
    return <NotFound />
  }

  const renderDescription = (text, highlights) => {
    let result = text
    highlights.forEach((highlight) => {
      const regex = new RegExp(`(${highlight})`, 'gi')
      result = result.replace(regex, '<strong>$1</strong>')
    })
    return result
  }

  return (
    <div className="location-detail-page">
      <PageMeta
        title={t('pages.locationDetail.metaTitle').replace('{name}', location.displayName)}
        description={t('pages.locationDetail.metaDescription')
          .replace('{name}', location.displayName)
          .replace('{address}', location.address)
          .replace('{city}', location.city)}
      />
      <section className="location-hero page-hero">
        <PageHeroMedia
          src={location.heroImage}
          alt={location.displayName}
          layout="photo"
        />
        <div className="container page-hero__content">
          <span className="location-hero-label">{t('pages.locationDetail.label')}</span>
          <h1 className="location-hero-title">{location.displayName}</h1>
        </div>
      </section>

      <section className="location-content">
        <div className="container">
          <div
            ref={(el) => (sectionRefs.current[0] = el)}
            className="location-main-layout animate-section"
          >
            <div className="location-text-content">
              <div className="label-badge">
                <FaHospital className="label-icon" />
                <span className="location-section-label">
                  {t('pages.locationDetail.atLocation')} {location.displayName.toUpperCase()}
                </span>
              </div>
              <h2 className="location-main-title">{location.title}</h2>
              <div className="description-wrapper">
                <p
                  className="location-description"
                  dangerouslySetInnerHTML={{
                    __html: renderDescription(location.description, location.highlights),
                  }}
                />
                <p className="location-description-2">{location.description2}</p>
                {location.description3 && (
                  <p className="location-description-3">{location.description3}</p>
                )}
              </div>
            </div>

            <div className="location-image-content">
              <div className="image-wrapper">
                <img
                  src={location.contentImage}
                  alt={`OrthoExpress ${location.displayName}`}
                  className="location-content-image"
                />
                <div className="image-overlay"></div>
              </div>
            </div>
          </div>

          {(location.services?.length > 0 || location.features?.length > 0) && (
            <div
              ref={(el) => (sectionRefs.current[1] = el)}
              className="location-services-features animate-section"
            >
              {location.services?.length > 0 && (
                <div className="services-section modern-card">
                  <div className="section-header">
                    <FaStethoscope className="section-icon" />
                    <h3 className="section-heading">{t('pages.locationDetail.ourServices')}</h3>
                  </div>
                  <ul className="services-list">
                    {location.services.map((service, index) => (
                      <li key={index} className="service-item">
                        <FaCheckCircle className="check-icon" />
                        <span>{service}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
              {location.features?.length > 0 && (
                <div className="features-section modern-card">
                  <div className="section-header">
                    <FaHospital className="section-icon" />
                    <h3 className="section-heading">{t('pages.locationDetail.locationFeatures')}</h3>
                  </div>
                  <ul className="features-list">
                    {location.features.map((feature, index) => (
                      <li key={index} className="feature-item">
                        <FaCheckCircle className="check-icon" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          )}

          <div
            ref={(el) => (sectionRefs.current[2] = el)}
            className="location-contact-cards animate-section"
          >
            <div className="contact-card contact-card-1">
              <div className="contact-icon-wrapper">
                <FaMapMarkerAlt className="contact-icon" />
              </div>
              <p className="contact-text">
                {location.address}, {location.city}
              </p>
            </div>
            <div className="contact-card contact-card-2">
              <div className="contact-icon-wrapper">
                <FaPhone className="contact-icon" />
              </div>
              <p className="contact-text">
                <a href={toTelLink(location.phone)}>{location.phone}</a>
              </p>
            </div>
            <div className="contact-card contact-card-3">
              <div className="contact-icon-wrapper">
                <FaClock className="contact-icon" />
              </div>
              <p className="contact-text">{location.hours}</p>
            </div>
          </div>

          <div className="location-action-row">
            <a
              href={getMapsDirectionsUrl(location)}
              target="_blank"
              rel="noopener noreferrer"
              className="btn btn-primary location-directions-btn"
            >
              <FaDirections /> {t('pages.locationDetail.getDirections')}
            </a>
            <Link to="/book-appointment" className="btn btn-outline location-book-btn">
              {t('pages.locationDetail.bookAppointment')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default LocationDetail
