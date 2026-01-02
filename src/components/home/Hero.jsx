import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone } from 'react-icons/fa'
import './Hero.css'

const Hero = () => {
  return (
    <section className="hero">
      <div 
        className="hero-background"
        style={{
          backgroundImage: 'url(https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=1920&h=1080&fit=crop)',
          backgroundSize: 'cover',
          backgroundPosition: 'center'
        }}
      >
        <div className="hero-overlay"></div>
      </div>
      <div className="hero-container">
        <div className="hero-content">
          <h1 className="hero-title">
            Expert Orthopedic Care<br />
            <span className="hero-title-accent">ON-Demand for All Ages</span>
          </h1>
          <div className="hero-buttons">
            <Link to="/book-appointment" className="btn-hero-primary">
              New Patient Registration →
            </Link>
            <a href="tel:+12149498918" className="btn-hero-phone">
              <FaPhone /> (214) 949-8918 →
            </a>
          </div>
        </div>
      </div>
      
      <div className="hero-features">
        <div className="container">
          <div className="hero-feature-card emergency-care">
            <h3>Emergency Care</h3>
            <p>Walk-in, same day appointments. No Referrals Required. Expert Care when YOU need it. In and out in less than an hour.</p>
            <a href="tel:+13055377272" className="feature-phone">(305) 537-7272</a>
            <Link to="/locations" className="btn-feature">Find A Center →</Link>
          </div>
          
          <div className="hero-feature-card instant-answers">
            <h3>Instant Answers</h3>
            <p>Questions? Call NOW. Speak with our knowledgeable, caring staff for instant answers to all your basic questions.</p>
            <a href="tel:+12149498918" className="feature-phone">(214) 949-8918 →</a>
          </div>
          
          <div className="hero-feature-card total-care">
            <h3>Total Orthopedic Care</h3>
            <p>Our highly credentialed healthcare professionals are ready to handle everything from sprains to auto-injuries, from pain to vein and much more.</p>
            <Link to="/about" className="btn-feature">About Us →</Link>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Hero

