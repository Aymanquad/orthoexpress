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
        </div>
      </div>

      <div className="hero-features">
        <div className="container">
          <div className="hero-feature-card emergency-care">
            <h3>{t('hero.urgentTitle')}</h3>
            <p>{t('hero.urgentText')}</p>
            <a href={toTelLink(headquarters.phone)} className="feature-phone">
              {headquarters.phone}
            </a>
            <br />
            <Link to="/locations" className="btn-feature">
              {t('hero.findCenter')}
            </Link>
          </div>

          <div className="hero-feature-card instant-answers">
            <h3>{t('hero.answersTitle')}</h3>
            <p>{t('hero.answersText')}</p>
            <a href={toTelLink(headquarters.phone)} className="feature-phone">
              {headquarters.phone}
            </a>
          </div>

          <div className="hero-feature-card total-care">
            <h3>{t('hero.totalTitle')}</h3>
            <p>{t('hero.totalText')}</p>
            <Link to="/about" className="btn-feature">
              {t('hero.aboutUs')}
            </Link>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Hero
