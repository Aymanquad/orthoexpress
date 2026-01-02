import React, { useState, useEffect } from 'react'
import { FaChevronLeft, FaChevronRight } from 'react-icons/fa'
import './ClinicServices.css'

const ClinicServices = () => {
  const [currentSlide, setCurrentSlide] = useState(0)

  const services = [
    {
      title: 'X-Ray Services',
      subtitle: 'Diagnosis',
      description: 'Orthopedic doctors use a variety of methods to diagnose musculoskeletal problems, including physical examinations, X-rays, MRIs, CT scans, and blood tests.'
    },
    {
      title: 'Non-surgical treatment',
      subtitle: 'Non-surgical treatment',
      description: 'Most musculoskeletal problems can be treated with non-surgical methods, such as medication, physical therapy, injections, bracing, and casting.'
    },
    {
      title: 'Pain management',
      subtitle: 'Pain management',
      description: 'Orthopedic doctors can help to manage pain from a variety of musculoskeletal conditions, using medication, injections, and other techniques.'
    },
    {
      title: 'Surgery',
      subtitle: 'Surgery',
      description: 'If non-surgical treatment is not effective, surgery may be necessary. Orthopedic surgeons perform a variety of procedures, including joint replacement, fracture repair, and ligament reconstruction.'
    },
    {
      title: 'Rehabilitation',
      subtitle: 'Rehabilitation',
      description: 'After surgery or other treatments, orthopedic doctors can help patients to regain their strength and mobility through physical therapy and other rehabilitation programs.'
    }
  ]

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
        <h2 className="section-title">We listen, we diagnose, we treat</h2>
        <p className="section-subtitle">Orthopedic clinic services</p>
        
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

