import React from 'react'
import { Link } from 'react-router-dom'
import { FaArrowRight } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import './WhatWeTreat.css'

const CARDS = [
  { key: 'injured', to: '/services/injuries-fractures-sprains' },
  { key: 'pain', to: '/services/pain-inflammation' },
  { key: 'scan', to: '/services/mri-digital-imaging' },
]

const WhatWeTreat = () => {
  const { t } = useLanguage()

  return (
    <section className="what-we-treat section">
      <div className="container">
        <h2 className="what-we-treat-title">{t('treat.title')}</h2>
        <p className="what-we-treat-subtitle">{t('treat.subtitle')}</p>
        <div className="what-we-treat-grid">
          {CARDS.map((card) => (
            <Link key={card.key} to={card.to} className="what-we-treat-card">
              <span>{t(`treat.${card.key}`)}</span>
              <FaArrowRight aria-hidden="true" />
            </Link>
          ))}
        </div>
        <Link to="/services" className="what-we-treat-all">
          {t('treat.viewAll')}
        </Link>
      </div>
    </section>
  )
}

export default WhatWeTreat
