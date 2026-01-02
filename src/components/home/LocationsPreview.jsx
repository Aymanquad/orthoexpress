import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaMapMarkerAlt, FaClock, FaDirections, FaCheckCircle } from 'react-icons/fa'
import './LocationsPreview.css'

const LocationsPreview = () => {
  const [hoveredIndex, setHoveredIndex] = useState(null)

  const locations = [
    {
      name: 'Lancaster',
      address: '2700 W Pleasant Run Road, Suite 340',
      city: 'Lancaster, TX 75146',
      phone: '(469) 225-0666',
      image: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800&h=600&fit=crop',
      hours: 'Mon-Fri: 8AM-6PM',
      features: ['Walk-in Available', 'X-Ray On-Site', 'Parking Available']
    },
    {
      name: 'Farmers Branch',
      address: '13988 Diplomat Drive, Suite 100',
      city: 'Farmers Branch, TX 75234',
      phone: '(214) 949-8918',
      image: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=800&h=600&fit=crop',
      hours: 'Mon-Fri: 8AM-6PM',
      features: ['Same-Day Appointments', 'Physical Therapy', 'Easy Access']
    },
    {
      name: 'Midland',
      address: '1304 West Texas Avenue',
      city: 'Midland, Texas 79701',
      phone: '(432) 599-9580',
      image: 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=800&h=600&fit=crop',
      hours: 'Mon-Fri: 8AM-6PM',
      features: ['Full Service Clinic', 'Expert Staff', 'Modern Facility']
    },
    {
      name: 'Waxahachie',
      address: '1324 Brown St#100',
      city: 'Waxahachie, Tx 75165',
      phone: '(972) 937-8900',
      image: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800&h=600&fit=crop',
      hours: 'Mon-Fri: 8AM-6PM',
      features: ['Comprehensive Care', 'Friendly Staff', 'Convenient Location']
    }
  ]

  return (
    <section className="locations-preview section">
      <div className="locations-background-pattern"></div>
      <div className="container">
        <div className="locations-header">
          <div className="locations-header-content">
            <span className="locations-label">FIND US NEAR YOU</span>
            <h2 className="section-title">
              Our <span className="highlight-text">Locations</span>
            </h2>
            <p className="section-subtitle">
              Where quality, convenience and affordability meet healthcare.
            </p>
            <div className="locations-phone-cta">
              <a href="tel:+12149498918" className="locations-phone-link">
                <FaPhone /> Call (214) 949-8918 →
              </a>
            </div>
          </div>
        </div>
        
        <div className="locations-creative-grid">
          {locations.map((location, index) => (
            <div 
              key={index} 
              className={`location-card-creative ${index % 2 === 0 ? 'card-left' : 'card-right'} ${hoveredIndex === index ? 'hovered' : ''}`}
              onMouseEnter={() => setHoveredIndex(index)}
              onMouseLeave={() => setHoveredIndex(null)}
            >
              <div className="location-card-inner">
                <div className="location-image-wrapper">
                  <img 
                    src={location.image} 
                    alt={`${location.name} Orthopedic Clinic`}
                    className="location-image"
                    loading="lazy"
                  />
                  <div className="location-gradient-overlay"></div>
                  <div className="location-number-badge">
                    <span>{index + 1}</span>
                  </div>
                  <div className="location-name-overlay">
                    <h3>{location.name}</h3>
                  </div>
                </div>
                
                <div className="location-card-content">
                  <div className="location-main-info">
                    <div className="location-address-section">
                      <FaMapMarkerAlt className="content-icon address-icon" />
                      <div>
                        <p className="location-address">{location.address}</p>
                        <p className="location-city">{location.city}</p>
                      </div>
                    </div>
                    
                    <div className="location-contact-section">
                      <div className="location-phone-section">
                        <FaPhone className="content-icon phone-icon" />
                        <a href={`tel:${location.phone.replace(/\D/g, '')}`} className="location-phone">
                          {location.phone}
                        </a>
                      </div>
                      
                      <div className="location-hours-section">
                        <FaClock className="content-icon clock-icon" />
                        <span className="location-hours">{location.hours}</span>
                      </div>
                    </div>
                  </div>

                  <div className="location-features">
                    {location.features.map((feature, fIndex) => (
                      <div key={fIndex} className="location-feature-item">
                        <FaCheckCircle className="feature-check" />
                        <span>{feature}</span>
                      </div>
                    ))}
                  </div>

                  <Link to="/locations" className="location-action-btn">
                    <FaDirections className="btn-icon" />
                    <span>Get Directions</span>
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default LocationsPreview

