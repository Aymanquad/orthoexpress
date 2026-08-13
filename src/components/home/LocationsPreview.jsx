import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaMapMarkerAlt, FaClock, FaDirections, FaCheckCircle } from 'react-icons/fa'
import { CLINIC, LOCATIONS, toTelLink, getMapsDirectionsUrl } from '../../data'
import { useLanguage } from '../../context/LanguageContext'
import { getLocalizedLocation } from '../../i18n/locations'
import './LocationsPreview.css'

const LocationsPreview = () => {
  const { t, lang } = useLanguage()
  const [hoveredIndex, setHoveredIndex] = useState(null)
  const { headquarters } = CLINIC

  return (
    <section className="locations-preview section">
      <div className="locations-background-pattern"></div>
      <div className="container">
        <div className="locations-header">
          <div className="locations-header-content">
            <span className="locations-label">{t('home.locationsPreview.label')}</span>
            <h2 className="section-title">
              {t('home.locationsPreview.title').includes('Locations') ? (
                <>
                  Our <span className="highlight-text">Locations</span>
                </>
              ) : (
                <>
                  Nuestras <span className="highlight-text">ubicaciones</span>
                </>
              )}
            </h2>
            <p className="section-subtitle">{t('home.locationsPreview.subtitle')}</p>
            <div className="locations-phone-cta">
              <a href={toTelLink(headquarters.phone)} className="locations-phone-link">
                <FaPhone /> {t('home.locationsPreview.call')} {headquarters.phone} →
              </a>
            </div>
          </div>
        </div>

        <div className="locations-creative-grid">
          {LOCATIONS.map((location, index) => {
            const localized = getLocalizedLocation(location.slug, lang)
            return (
            <div
              key={location.slug}
              className={`location-card-creative ${index % 2 === 0 ? 'card-left' : 'card-right'} ${hoveredIndex === index ? 'hovered' : ''}`}
              onMouseEnter={() => setHoveredIndex(index)}
              onMouseLeave={() => setHoveredIndex(null)}
            >
              <div className="location-card-inner">
                <div className="location-image-wrapper">
                  <img
                    src={location.image}
                    alt={`${location.name} ${t('home.locationsPreview.clinicAlt')}`}
                    className="location-image"
                    loading="lazy"
                  />
                  <div className="location-gradient-overlay"></div>
                  <div className="location-number-badge">
                    <span>{index + 1}</span>
                  </div>
                  <div className="location-name-overlay">
                    <h3>{location.name}</h3>
                  </div>
                </div>

                <div className="location-card-content">
                  <div className="location-main-info">
                    <div className="location-address-section">
                      <FaMapMarkerAlt className="content-icon address-icon" />
                      <div>
                        <p className="location-address">{location.address}</p>
                        <p className="location-city">{location.city}</p>
                      </div>
                    </div>

                    <div className="location-contact-section">
                      <div className="location-phone-section">
                        <FaPhone className="content-icon phone-icon" />
                        <a href={toTelLink(location.phone)} className="location-phone">
                          {location.phone}
                        </a>
                      </div>

                      <div className="location-hours-section">
                        <FaClock className="content-icon clock-icon" />
                        <span className="location-hours">
                          {localized.hoursShort}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div className="location-features">
                    {localized.cardFeatures.map((feature, fIndex) => (
                      <div key={fIndex} className="location-feature-item">
                        <FaCheckCircle className="feature-check" />
                        <span>{feature}</span>
                      </div>
                    ))}
                  </div>

                  <div className="location-action-buttons">
                    <Link to={`/locations/${location.slug}`} className="location-action-btn">
                      {t('home.locationsPreview.viewLocation')}
                    </Link>
                    <a
                      href={getMapsDirectionsUrl(location)}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="location-directions-btn"
                    >
                      <FaDirections className="btn-icon" />
                      <span>{t('home.locationsPreview.getDirections')}</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
            )
          })}
        </div>
      </div>
    </section>
  )
}

export default LocationsPreview
