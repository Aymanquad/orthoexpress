import React from 'react'
import { useLanguage } from '../../context/LanguageContext'
import GoogleReviewsWidget from './GoogleReviewsWidget'
import './ReviewsBar.css'

const ReviewsBar = () => {
  const { t } = useLanguage()

  return (
    <section className="reviews-bar">
      <div className="container">
        <div className="reviews-bar-header">
          <div>
            <h2 className="reviews-bar-title">{t('reviews.title')}</h2>
            <p className="reviews-bar-subtitle">{t('reviews.subtitle')}</p>
          </div>
          <div className="reviews-trust-stats">
            <div className="reviews-trust-stat">
              <strong>150K+</strong>
              <span>{t('home.stats.happyPatients')}</span>
            </div>
            <div className="reviews-trust-stat">
              <strong>200K+</strong>
              <span>{t('home.stats.patientsServed')}</span>
            </div>
          </div>
        </div>

        <GoogleReviewsWidget />
      </div>
    </section>
  )
}

export default ReviewsBar
