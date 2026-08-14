import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaMapMarkerAlt, FaClock, FaDirections, FaArrowRight } from 'react-icons/fa'
import { LOCATIONS, toTelLink, getMapsDirectionsUrl } from '../../data'
import { useLanguage } from '../../context/LanguageContext'
import { getLocalizedLocation } from '../../i18n/locations'
import './LocationsPreview.css'

const LocationsPreview = () => {
  const { t, lang } = useLanguage()

  return (
    <section className="locations-preview">
      <div className="container">
        <div className="locations-header">
          <div>
            <span className="locations-label">{t('home.locationsPreview.label')}</span>
            <h2 className="locations-title">{t('home.locationsPreview.title')}</h2>
            <p className="locations-subtitle">{t('home.locationsPreview.subtitle')}</p>
          </div>
          <Link to="/locations" className="locations-all">
            {t('home.locationsPreview.viewAll')} <FaArrowRight aria-hidden="true" />
          </Link>
        </div>

        <div className="locations-grid">
          {LOCATIONS.map((location) => {
            const localized = getLocalizedLocation(location.slug, lang)
            const features = (localized.cardFeatures || []).slice(0, 2)

            return (
              <article key={location.slug} className="location-card">
                <Link
                  to={`/locations/${location.slug}`}
                  className="location-card-media"
                  aria-label={location.name}
                >
                  <img
                    src={location.image}
                    alt={`${location.name} ${t('home.locationsPreview.clinicAlt')}`}
                    className="location-image"
                    loading="lazy"
                  />
                </Link>

                <div className="location-card-body">
                  <h3 className="location-name">{location.name}</h3>
                  <p className="location-address">
                    <FaMapMarkerAlt aria-hidden="true" />
                    <span>
                      {location.address}
                      <br />
                      {location.city}
                    </span>
                  </p>
                  <p className="location-meta">
                    <a href={toTelLink(location.phone)} className="location-phone">
                      <FaPhone aria-hidden="true" /> {location.phone}
                    </a>
                    <span className="location-hours">
                      <FaClock aria-hidden="true" /> {localized.hoursShort}
                    </span>
                  </p>

                  {features.length > 0 && (
                    <div className="location-pills">
                      {features.map((feature) => (
                        <span key={feature} className="location-pill">{feature}</span>
                      ))}
                    </div>
                  )}

                  <div className="location-actions">
                    <Link to={`/locations/${location.slug}`} className="location-btn location-btn-primary">
                      {t('home.locationsPreview.viewLocation')}
                    </Link>
                    <a
                      href={getMapsDirectionsUrl(location)}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="location-btn location-btn-outline"
                    >
                      <FaDirections aria-hidden="true" />
                      {t('home.locationsPreview.getDirections')}
                    </a>
                  </div>
                </div>
              </article>
            )
          })}
        </div>
      </div>
    </section>
  )
}

export default LocationsPreview
