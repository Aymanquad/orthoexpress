import React, { useState, useEffect } from 'react'
import { FaChevronLeft, FaChevronRight } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import './ClinicServices.css'

const ClinicServices = () => {
  const { t } = useLanguage()
  const [currentSlide, setCurrentSlide] = useState(0)

  const services = t('home.clinicServices.slides')

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % services.length)
    }, 5000)
    return () => clearInterval(interval)
  }, [services.length])

  const goToPrevious = () => {
    setCurrentSlide((prev) => (prev - 1 + services.length) % services.length)
  }

  const goToNext = () => {
    setCurrentSlide((prev) => (prev + 1) % services.length)
  }

  return (
    <section className="clinic-services section">
      <div className="container">
        <h2 className="section-title">{t('home.clinicServices.title')}</h2>
        <p className="section-subtitle">{t('home.clinicServices.subtitle')}</p>

        <div className="services-carousel">
          <button className="carousel-btn carousel-btn-left" onClick={goToPrevious}>
            <FaChevronLeft />
          </button>

          <div className="carousel-container">
            <div
              className="carousel-track"
              style={{ transform: `translateX(-${currentSlide * 100}%)` }}
            >
              {services.map((service, index) => (
                <div key={index} className="carousel-slide">
                  <div className="service-slide-content">
                    <h3 className="service-slide-title">{service.title}</h3>
                    <h4 className="service-slide-subtitle">{service.subtitle}</h4>
                    <p className="service-slide-description">{service.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <button className="carousel-btn carousel-btn-right" onClick={goToNext}>
            <FaChevronRight />
          </button>
        </div>

        <div className="carousel-dots">
          {services.map((_, index) => (
            <button
              key={index}
              className={`dot ${index === currentSlide ? 'active' : ''}`}
              onClick={() => setCurrentSlide(index)}
            />
          ))}
        </div>
      </div>
    </section>
  )
}

export default ClinicServices
