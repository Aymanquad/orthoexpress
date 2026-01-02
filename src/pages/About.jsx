import React, { useEffect, useRef } from 'react'
import './About.css'

const About = () => {
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
      <section className="about-hero section">
        <div className="about-hero-background">
          <img 
            src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=1920&h=1080&fit=crop" 
            alt="Medical clinic"
            className="about-hero-image"
          />
          <div className="about-hero-overlay"></div>
        </div>
        <div className="container">
          <h1 className="page-title">About OrthoExpress</h1>
          <p className="page-subtitle">Your Trusted Orthopedic Care Partner</p>
        </div>
      </section>

      {/* Mission - Split Layout Left Image Right Text */}
      <section ref={(el) => (sectionsRef.current[0] = el)} className="split-section mission-section">
        <div className="split-image-left">
          <img 
            src="https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=1000&h=800&fit=crop" 
            alt="Caring medical professional"
            className="split-image"
          />
          <div className="image-overlay-gradient"></div>
        </div>
        <div className="split-content-right">
          <div className="split-content-inner">
            <span className="section-label">Our Mission</span>
            <h2 className="split-title">Dedicated to Your Recovery</h2>
            <p className="split-text">
              At OrthoExpress, we are dedicated to providing exceptional orthopedic care 
              that is accessible, personalized, and focused on your recovery. Our mission 
              is to help you regain your mobility, reduce pain, and return to the activities 
              you love as quickly and safely as possible.
            </p>
            <p className="split-text">
              We believe that quality healthcare should be available when you need it most. 
              That's why we've built a practice centered around your convenience and comfort, 
              ensuring that every interaction is focused on your healing and well-being.
            </p>
          </div>
        </div>
      </section>

      {/* Vision - Split Layout Right Image Left Text */}
      <section ref={(el) => (sectionsRef.current[1] = el)} className="split-section vision-section">
        <div className="split-content-left">
          <div className="split-content-inner">
            <span className="section-label">Our Vision</span>
            <h2 className="split-title">Healthcare Without Barriers</h2>
            <p className="split-text">
              We envision a healthcare system where orthopedic care is readily available 
              when you need it most. By offering walk-in appointments and same-day service, 
              we eliminate the barriers that often delay treatment and recovery.
            </p>
            <p className="split-text">
              Our vision extends beyond just treating injuries—we're committed to transforming 
              how orthopedic care is delivered, making it more accessible, efficient, and 
              patient-centered for everyone in our community.
            </p>
          </div>
        </div>
        <div className="split-image-right">
          <img 
            src="https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1000&h=800&fit=crop" 
            alt="Modern medical facility"
            className="split-image"
          />
          <div className="image-overlay-gradient"></div>
        </div>
      </section>

      {/* Why Choose Us - Large Background Image with Overlapping Cards */}
      <section ref={(el) => (sectionsRef.current[2] = el)} className="features-hero-section">
        <div className="features-background">
          <img 
            src="https://images.unsplash.com/photo-1582719471384-894fbb16e074?w=1920&h=1200&fit=crop" 
            alt="Medical facility"
            className="features-bg-image"
          />
          <div className="features-overlay"></div>
        </div>
        <div className="container">
          <div className="features-header">
            <span className="section-label-white">Why Choose Us</span>
            <h2 className="features-main-title">Excellence in Every Aspect</h2>
          </div>
          <div className="features-overlap-grid">
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                  <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
              </div>
              <h3>No Appointment Necessary</h3>
              <p>Walk in and receive expert care when you need it, without the wait.</p>
            </div>
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                  <circle cx="12" cy="7" r="4"></circle>
                </svg>
              </div>
              <h3>Expert Physicians</h3>
              <p>Board-certified orthopedic surgeons with years of experience.</p>
            </div>
            <div className="feature-item">
              <div className="feature-icon-circle">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                  <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
              </div>
              <h3>Comprehensive Care</h3>
              <p>From diagnosis to rehabilitation, we provide complete orthopedic services.</p>
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
              <h3>Personalized Treatment</h3>
              <p>Every patient receives individualized care tailored to their unique needs.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Our Story - Full Width Image with Text Overlay */}
      <section ref={(el) => (sectionsRef.current[3] = el)} className="story-section">
        <div className="story-image-container">
          <img 
            src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=1920&h=1000&fit=crop" 
            alt="Caring medical team"
            className="story-background-image"
          />
          <div className="story-content-overlay">
            <div className="container">
              <div className="story-content-wrapper">
                <span className="section-label-white">Our Story</span>
                <h2 className="story-title">Built on Compassion and Excellence</h2>
                <div className="story-text-container">
                  <p className="story-text">
                    OrthoExpress was founded with a simple goal: to make quality orthopedic care 
                    accessible to everyone. We recognized that injuries don't wait for appointments, 
                    and neither should your treatment. Our walk-in clinic model ensures that you 
                    can receive expert orthopedic care on the same day, helping you start your 
                    recovery journey immediately.
                  </p>
                  <p className="story-text">
                    Over the years, we have built a reputation for excellence, compassion, and 
                    innovation in orthopedic medicine. Our team of dedicated professionals works 
                    tirelessly to provide the highest standard of care while maintaining the 
                    personal touch that makes all the difference in your healing process.
                  </p>
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

