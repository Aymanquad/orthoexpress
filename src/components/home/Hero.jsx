import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaMapMarkerAlt } from 'react-icons/fa'
import { CLINIC } from '../../data'
import { toTelLink } from '../../data/utils'
import { useLanguage } from '../../context/LanguageContext'
import { IMAGES } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './Hero.css'

const Hero = () => {
  const { headquarters } = CLINIC
  const { t } = useLanguage()

  return (
    <section className="hero">
      <div className="hero-background">
        <ImageWithFallback
          src={IMAGES.home.hero.src}
          fallback={IMAGES.home.hero.fallback}
          alt=""
          className="hero-background-img"
          style={
            IMAGES.home.hero.objectPosition
              ? { objectPosition: IMAGES.home.hero.objectPosition }
              : undefined
          }
        />
        <div className="hero-overlay"></div>
      </div>
      <div className="hero-container">
        <div className="hero-content">
          <span className="hero-eyebrow">{t('hero.eyebrow')}</span>
          <h1 className="hero-title">
            {t('hero.title')}
            <span className="hero-title-accent">{t('hero.titleAccent')}</span>
          </h1>
          <p className="hero-lead">{t('hero.lead')}</p>
          <div className="hero-buttons">
            <Link to="/book-appointment" className="btn-hero-primary">
              {t('hero.book')}
            </Link>
            <Link to="/locations" className="btn-hero-secondary">
              <FaMapMarkerAlt aria-hidden="true" /> {t('hero.findCenter')}
            </Link>
            <a href={toTelLink(headquarters.phone)} className="btn-hero-phone">
              <FaPhone aria-hidden="true" /> {headquarters.phone}
            </a>
          </div>
          <ul className="hero-trust">
            <li>{t('hero.trustWalkIn')}</li>
            <li>{t('hero.trustSameDay')}</li>
            <li>{t('hero.trustInsurance')}</li>
          </ul>
        </div>
      </div>
    </section>
  )
}

export default Hero
