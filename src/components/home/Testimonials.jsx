import React, { useState, useEffect } from 'react'
import { FaChevronLeft, FaChevronRight, FaUser } from 'react-icons/fa'
import './Testimonials.css'

const Testimonials = () => {
  const testimonials = [
    {
      name: 'B.C.',
      location: 'Lancaster',
      text: "One of the most thoughtful and caring physicians out there! He is so good with all things orthopedics and sports care. He has such good outcomes from his surgeries. Highly recommend for your orthopedic needs!"
    },
    {
      name: 'John DB',
      location: 'Midland',
      text: "Recent surgery, quick recovery thanks to Orthocare's skilled team. Highly recommend!"
    },
    {
      name: 'Alfonso L.',
      location: 'Waxachie',
      text: "Awesome service, great attention and fast response from the Orthocare team in Waxachie, great people taking care fast and secure to their patients."
    },
    {
      name: 'Michelle B.',
      location: 'Farmers Branch',
      text: "Orthocare's expertise got me back on the field, pain-free! Thanks for the excellent care."
    }
  ]

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
        <h2 className="section-title">Hear from our happy Patients</h2>
        <div className="testimonials-slider">
          <button className="slider-btn slider-btn-left" onClick={goToPrevious}>
            <FaChevronLeft />
          </button>
          <div className="testimonial-card">
            <div className="testimonial-header">
              <div className="testimonial-icon-wrapper">
                <FaUser className="testimonial-icon" />
              </div>
              <div>
                <span className="testimonial-label">Patient</span>
              </div>
            </div>
            <p className="testimonial-text">
              "{testimonials[currentIndex].text}"
            </p>
            <div className="testimonial-author">
              <span className="author-name">{testimonials[currentIndex].name}</span>
              <span className="author-location">{testimonials[currentIndex].location}</span>
            </div>
          </div>
          <button className="slider-btn slider-btn-right" onClick={goToNext}>
            <FaChevronRight />
          </button>
        </div>
        <div className="testimonial-dots">
          {testimonials.map((_, index) => (
            <button
              key={index}
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

