import React, { useEffect, useRef } from 'react'
import PageMeta from '../components/PageMeta'
import { useLanguage } from '../context/LanguageContext'
import { IMAGES } from '../data/images'
import PageHeroMedia from '../components/PageHeroMedia'
import ImageWithFallback from '../components/ImageWithFallback'
import './About.css'

const About = () => {
  const { t } = useLanguage()
  const sectionsRef = useRef([])

  useEffect(() => {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -100px 0px'
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in')
        }
      })
    }, observerOptions)

    sectionsRef.current.forEach((section) => {
      if (section) observer.observe(section)
    })

    return () => {
      sectionsRef.current.forEach((section) => {
        if (section) observer.unobserve(section)
      })
    }
  }, [])

  return (
    <div className="about-page">
      <PageMeta
        title={t('pages.meta.about.title')}
        description={t('pages.meta.about.description')}
      />
      <section className="about-hero page-hero section">
        <PageHeroMedia
          src={IMAGES.about.hero.src}
          fallback={IMAGES.about.hero.fallback}
          layout="photo"
        />
        <div className="container page-hero__content">
          <h1 className="page-title">{t('pages.about.title')}</h1>
          <p className="page-subtitle">{t('pages.about.subtitle')}</p>
        </div>
      </section>

      <section ref={(el) => (sectionsRef.current[0] = el)} className="split-section mission-section">
        <div className="split-image-left">
          <ImageWithFallback
            src={IMAGES.about.team.src}
            fallback={IMAGES.about.team.fallback}
            alt=""
            className="split-image"
          />
          <div className="image-overlay-gradient"></div>
        </div>
        <div className="split-content-right">
          <div className="split-content-inner">
            <span className="section-label">{t('pages.about.missionLabel')}</span>
            <h2 className="split-title">{t('pages.about.missionTitle')}</h2>
            <p className="split-text">{t('pages.about.missionP1')}</p>
            <p className="split-text">{t('pages.about.missionP2')}</p>
          </div>
        </div>
      </section>

      <section ref={(el) => (sectionsRef.current[1] = el)} className="split-section vision-section">
        <div className="split-content-left">
          <div className="split-content-inner">
            <span className="section-label">{t('pages.about.visionLabel')}</span>
            <h2 className="split-title">{t('pages.about.visionTitle')}</h2>
            <p className="split-text">{t('pages.about.visionP1')}</p>
            <p className="split-text">{t('pages.about.visionP2')}</p>
          </div>
        </div>
        <div className="split-image-right">
          <ImageWithFallback
            src={IMAGES.about.facility.src}
            fallback={IMAGES.about.facility.fallback}
            alt=""
            className="split-image"
          />
          <div className="image-overlay-gradient"></div>
        </div>
      </section>

      <section ref={(el) => (sectionsRef.current[2] = el)} className="features-hero-section">
        <div className="features-background">
          <ImageWithFallback
            src={IMAGES.about.facility.src}
            fallback={IMAGES.about.facility.fallback}
            alt=""
            className="features-bg-image"
          />
          <div className="features-overlay"></div>
        </div>
        <div className="container">
          <div className="features-header">
            <span className="section-label-white">{t('pages.about.whyLabel')}</span>
            <h2 className="features-main-title">{t('pages.about.whyTitle')}</h2>
          </div>
          <div className="features-overlap-grid">
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                  <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
              </div>
              <h3>{t('pages.about.feature1Title')}</h3>
              <p>{t('pages.about.feature1Text')}</p>
            </div>
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                  <circle cx="12" cy="7" r="4"></circle>
                </svg>
              </div>
              <h3>{t('pages.about.feature2Title')}</h3>
              <p>{t('pages.about.feature2Text')}</p>
            </div>
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                  <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
              </div>
              <h3>{t('pages.about.feature3Title')}</h3>
              <p>{t('pages.about.feature3Text')}</p>
            </div>
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                  <circle cx="9" cy="7" r="4"></circle>
                  <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                  <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
              </div>
              <h3>{t('pages.about.feature4Title')}</h3>
              <p>{t('pages.about.feature4Text')}</p>
            </div>
          </div>
        </div>
      </section>

      <section ref={(el) => (sectionsRef.current[3] = el)} className="story-section">
        <div className="story-image-container">
          <ImageWithFallback
            src={IMAGES.about.care.src}
            fallback={IMAGES.about.care.fallback}
            alt=""
            className="story-background-image"
          />
          <div className="story-content-overlay">
            <div className="container">
              <div className="story-content-wrapper">
                <span className="section-label-white">{t('pages.about.storyLabel')}</span>
                <h2 className="story-title">{t('pages.about.storyTitle')}</h2>
                <div className="story-text-container">
                  <p className="story-text">{t('pages.about.storyP1')}</p>
                  <p className="story-text">{t('pages.about.storyP2')}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default About
