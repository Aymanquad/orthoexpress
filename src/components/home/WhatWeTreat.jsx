import React from 'react'
import { Link } from 'react-router-dom'
import { FaArrowRight } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import { getServiceImage, IMAGES } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './WhatWeTreat.css'

const CARDS = [
  { key: 'injured', image: IMAGES.home.snapshotInjured, to: '/services/injuries-fractures-sprains' },
  { key: 'pain', slug: 'arthritis', to: '/services/pain-inflammation' },
  { key: 'scan', slug: 'mri-digital-imaging', to: '/services/mri-digital-imaging' },
  { key: 'sports', image: IMAGES.home.snapshotSports, to: '/services/sports-medicine' },
  { key: 'spine', slug: 'lumbar-cervical-spine', to: '/services/lumbar-cervical-spine' },
  { key: 'workers', image: IMAGES.home.snapshotWorkers, to: '/workers-comp' },
]

const WhatWeTreat = () => {
  const { t } = useLanguage()

  return (
    <section className="what-we-treat section">
      <div className="container">
        <h2 className="what-we-treat-title">{t('treat.title')}</h2>
        <p className="what-we-treat-subtitle">{t('treat.subtitle')}</p>
        <div className="what-we-treat-grid">
          {CARDS.map((card) => {
            const img = card.image || getServiceImage(card.slug)
            return (
              <Link key={card.key} to={card.to} className="what-we-treat-card">
                <div className="what-we-treat-card-media">
                  <ImageWithFallback
                    src={img.src}
                    fallback={img.fallback}
                    alt=""
                    className="what-we-treat-card-img"
                  />
                </div>
                <div className="what-we-treat-card-content">
                  <span className="what-we-treat-card-label">{t(`treat.${card.key}`)}</span>
                  <FaArrowRight className="what-we-treat-card-arrow" aria-hidden="true" />
                </div>
              </Link>
            )
          })}
        </div>
        <Link to="/services" className="what-we-treat-all">
          {t('treat.viewAll')}
        </Link>
      </div>
    </section>
  )
}

export default WhatWeTreat
