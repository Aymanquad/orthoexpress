import React from 'react'
import { useLanguage } from '../../context/LanguageContext'
import GoogleReviewsWidget from './GoogleReviewsWidget'
import './ReviewsBar.css'

const ReviewsBar = () => {
  const { t } = useLanguage()

  return (
    <section className="reviews-bar section">
      <div className="container">
        <div className="reviews-bar-header">
          <div>
            <h2 className="reviews-bar-title">{t('reviews.title')}</h2>
            <p className="reviews-bar-subtitle">{t('reviews.subtitle')}</p>
          </div>
        </div>

        <GoogleReviewsWidget />
      </div>
    </section>
  )
}

export default ReviewsBar
