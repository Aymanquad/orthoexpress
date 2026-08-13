import React, { useState, useEffect } from 'react'
import { FaChevronLeft, FaChevronRight, FaUser } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import './Testimonials.css'

const Testimonials = () => {
  const { t } = useLanguage()
  const testimonials = t('home.testimonials.items')
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % testimonials.length)
    }, 5000)
    return () => clearInterval(interval)
  }, [testimonials.length])

  const goToPrevious = () => {
    setCurrentIndex((prev) => (prev - 1 + testimonials.length) % testimonials.length)
  }

  const goToNext = () => {
    setCurrentIndex((prev) => (prev + 1) % testimonials.length)
  }

  return (
    <section className="testimonials section">
      <div className="container">
        <h2 className="section-title">{t('home.testimonials.title')}</h2>
        <div className="testimonials-slider" aria-roledescription="carousel" aria-label={t('home.testimonials.title')}>
          <button className="slider-btn slider-btn-left" onClick={goToPrevious} aria-label={t('home.testimonials.prev')}>
            <FaChevronLeft />
          </button>
          <div className="testimonial-card" aria-live="polite">
            <div className="testimonial-header">
              <div className="testimonial-icon-wrapper">
                <FaUser className="testimonial-icon" />
              </div>
              <div>
                <span className="testimonial-label">{t('home.testimonials.patient')}</span>
              </div>
            </div>
            <p className="testimonial-text">"{testimonials[currentIndex].text}"</p>
            <div className="testimonial-author">
              <span className="author-name">{testimonials[currentIndex].name}</span>
              <span className="author-location">{testimonials[currentIndex].location}</span>
            </div>
          </div>
          <button className="slider-btn slider-btn-right" onClick={goToNext} aria-label={t('home.testimonials.next')}>
            <FaChevronRight />
          </button>
        </div>
        <div className="testimonial-dots" role="tablist" aria-label={t('home.testimonials.title')}>
          {testimonials.map((_, index) => (
            <button
              key={index}
              type="button"
              role="tab"
              aria-selected={index === currentIndex}
              aria-label={`${t('home.testimonials.goTo')} ${index + 1}`}
              className={`dot ${index === currentIndex ? 'active' : ''}`}
              onClick={() => setCurrentIndex(index)}
            />
          ))}
        </div>
      </div>
    </section>
  )
}

export default Testimonials
