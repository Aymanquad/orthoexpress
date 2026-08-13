import React from 'react'
import { Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaPhone, FaClock, FaDirections } from 'react-icons/fa'
import { LOCATIONS } from '../data'
import { getMapsDirectionsUrl } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import './Locations.css'

const Locations = () => {
  const { t } = useLanguage()

  return (
    <div className="locations-page">
      <PageMeta
        title={t('pages.meta.locations.title')}
        description={t('pages.meta.locations.description')}
      />

      <section className="locations-hero section">
        <div className="container">
          <span className="locations-label">{t('pages.locations.label')}</span>
          <h1 className="page-title">{t('pages.locations.title')}</h1>
        </div>
      </section>

      <section className="locations-content section">
        <div className="container">
          <div className="locations-grid">
            {LOCATIONS.map((location) => (
              <article key={location.slug} className="locations-page-card">
                <div className="locations-page-card-icon">
                  <FaMapMarkerAlt />
                </div>
                <div className="locations-page-card-body">
                  <h2 className="locations-page-name">{location.name}</h2>
                  <p className="locations-page-address">{location.address}</p>
                  <p className="locations-page-city">{location.city}</p>
                  <div className="locations-page-contact">
                    <div className="locations-page-contact-item">
                      <FaPhone className="locations-page-contact-icon" />
                      <span>{location.phone}</span>
                    </div>
                    <div className="locations-page-contact-item">
                      <FaClock className="locations-page-contact-icon" />
                      <span>{location.hours}</span>
                    </div>
                  </div>
                  <div className="locations-page-actions">
                    <Link to={`/locations/${location.slug}`} className="locations-page-btn locations-page-btn-primary">
                      {t('pages.locations.viewDetails')}
                    </Link>
                    <a
                      href={getMapsDirectionsUrl(location)}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="locations-page-btn locations-page-btn-secondary"
                    >
                      <FaDirections /> {t('pages.locations.directions')}
                    </a>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Locations
