import React from 'react'
import './About.css'

const About = () => {
  return (
    <div className="about-page">
      <section className="about-hero section">
        <div className="container">
          <h1 className="page-title">About Orthoexpress</h1>
          <p className="page-subtitle">Your Trusted Orthopedic Care Partner</p>
        </div>
      </section>

      <section className="about-content section">
        <div className="container">
          <div className="about-section">
            <h2>Our Mission</h2>
            <p>
              At Orthoexpress, we are dedicated to providing exceptional orthopedic care 
              that is accessible, personalized, and focused on your recovery. Our mission 
              is to help you regain your mobility, reduce pain, and return to the activities 
              you love as quickly and safely as possible.
            </p>
          </div>

          <div className="about-section">
            <h2>Our Vision</h2>
            <p>
              We envision a healthcare system where orthopedic care is readily available 
              when you need it most. By offering walk-in appointments and same-day service, 
              we eliminate the barriers that often delay treatment and recovery.
            </p>
          </div>

          <div className="about-section">
            <h2>Why Choose Us</h2>
            <div className="features-grid">
              <div className="feature-card">
                <h3>No Appointment Necessary</h3>
                <p>Walk in and receive expert care when you need it, without the wait.</p>
              </div>
              <div className="feature-card">
                <h3>Expert Physicians</h3>
                <p>Board-certified orthopedic surgeons with years of experience.</p>
              </div>
              <div className="feature-card">
                <h3>Comprehensive Care</h3>
                <p>From diagnosis to rehabilitation, we provide complete orthopedic services.</p>
              </div>
              <div className="feature-card">
                <h3>Personalized Treatment</h3>
                <p>Every patient receives individualized care tailored to their unique needs.</p>
              </div>
            </div>
          </div>

          <div className="about-section">
            <h2>Our Story</h2>
            <p>
              Orthoexpress was founded with a simple goal: to make quality orthopedic care 
              accessible to everyone. We recognized that injuries don't wait for appointments, 
              and neither should your treatment. Our walk-in clinic model ensures that you 
              can receive expert orthopedic care on the same day, helping you start your 
              recovery journey immediately.
            </p>
            <p>
              Over the years, we have built a reputation for excellence, compassion, and 
              innovation in orthopedic medicine. Our team of dedicated professionals works 
              tirelessly to provide the highest standard of care while maintaining the 
              personal touch that makes all the difference in your healing process.
            </p>
          </div>
        </div>
      </section>
    </div>
  )
}

export default About

