import React from 'react'
import { Link } from 'react-router-dom'
import { useLanguage } from '../../context/LanguageContext'
import { getServiceImage } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './TreatmentAreas.css'

const SLUGS = [
  'hand-wrist-care',
  'shoulder-elbow',
  'lumbar-cervical-spine',
  'hip-knee-care',
  'foot-ankle-care',
  'total-joint-replacement',
]

const TreatmentAreas = () => {
  const { t } = useLanguage()
  const areas = t('home.treatmentAreas.areas')

  return (
    <section className="treatment-areas section">
      <div className="container">
        <h2 className="section-title">{t('home.treatmentAreas.title')}</h2>
        <p className="section-subtitle">{t('home.treatmentAreas.subtitle')}</p>
        <div className="treatment-areas-grid">
          {areas.map((area, index) => {
            const image = getServiceImage(SLUGS[index])
            return (
            <Link
              key={SLUGS[index]}
              to={`/services/${SLUGS[index]}`}
              className="treatment-area-card"
            >
              <div className="treatment-area-image-wrapper">
                <ImageWithFallback
                  src={image.src}
                  fallback={image.fallback}
                  alt={area.title}
                  className="treatment-area-image"
                  loading="lazy"
                />
                <div className="treatment-area-overlay"></div>
              </div>
              <div className="treatment-area-content">
                <h3 className="treatment-area-title">{area.title}</h3>
                <p className="treatment-area-description">{area.description}</p>
              </div>
            </Link>
            )
          })}
        </div>
      </div>
    </section>
  )
}

export default TreatmentAreas
