import React from 'react'
import { Link } from 'react-router-dom'
import { useLanguage } from '../../context/LanguageContext'
import { IMAGES } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './ServicesSnapshot.css'

const ServicesSnapshot = () => {
  const { t } = useLanguage()

  return (
    <section className="services-snapshot section">
      <div className="container">
        <div className="services-header">
          <span className="services-label">{t('home.servicesSnapshot.label')}</span>
          <h2 className="section-title">{t('home.servicesSnapshot.title')}</h2>
          <p className="services-description">
            {t('home.servicesSnapshot.desc1').includes('Orthopedic Services') ? (
              <>
                Our <span className="highlight">{t('home.servicesSnapshot.orthopedicServices')}</span>
                {t('home.servicesSnapshot.desc1').split('Orthopedic Services')[1]}
              </>
            ) : (
              <>
                Nuestros <span className="highlight">{t('home.servicesSnapshot.orthopedicServices')}</span>
                {t('home.servicesSnapshot.desc1').split('Servicios Ortopédicos')[1]}
              </>
            )}
          </p>
          <p className="services-description">
            {t('home.servicesSnapshot.desc2').includes('orthopedic specialists') ? (
              <>
                {t('home.servicesSnapshot.desc2').split('orthopedic specialists')[0]}
                <span className="highlight">{t('home.servicesSnapshot.specialists')}</span>
                {t('home.servicesSnapshot.desc2').split('orthopedic specialists')[1]}
              </>
            ) : (
              <>
                {t('home.servicesSnapshot.desc2').split('especialistas ortopédicos')[0]}
                <span className="highlight">{t('home.servicesSnapshot.specialists')}</span>
                {t('home.servicesSnapshot.desc2').split('especialistas ortopédicos')[1]}
              </>
            )}
          </p>
        </div>

        <div className="no-appointment-banner">
          <h3>{t('home.servicesSnapshot.walkInTitle')}</h3>
          <h2>{t('home.servicesSnapshot.walkInSubtitle')}</h2>
        </div>

        <div className="special-services">
          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <ImageWithFallback
                src={IMAGES.home.snapshotInjured.src}
                fallback={IMAGES.home.snapshotInjured.fallback}
                alt={t('home.servicesSnapshot.injuriesTitle')}
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>{t('home.servicesSnapshot.injuriesTitle')}</h3>
              <p>{t('home.servicesSnapshot.injuriesDesc')}</p>
              <Link to="/services/injuries-fractures-sprains" className="know-more-link">
                {t('home.servicesSnapshot.knowMore')}
              </Link>
            </div>
          </div>

          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <ImageWithFallback
                src={IMAGES.home.snapshotSports.src}
                fallback={IMAGES.home.snapshotSports.fallback}
                alt={t('home.servicesSnapshot.sportsTitle')}
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>{t('home.servicesSnapshot.sportsTitle')}</h3>
              <p>{t('home.servicesSnapshot.sportsDesc')}</p>
              <Link to="/services/sports-medicine" className="know-more-link">
                {t('home.servicesSnapshot.knowMore')}
              </Link>
            </div>
          </div>

          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <ImageWithFallback
                src={IMAGES.home.snapshotWorkers.src}
                fallback={IMAGES.home.snapshotWorkers.fallback}
                alt={t('home.servicesSnapshot.workersTitle')}
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>{t('home.servicesSnapshot.workersTitle')}</h3>
              <p>{t('home.servicesSnapshot.workersDesc')}</p>
              <Link to="/workers-comp" className="know-more-link">
                {t('home.servicesSnapshot.knowMore')}
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default ServicesSnapshot
