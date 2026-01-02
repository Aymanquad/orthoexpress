import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaBars, FaTimes } from 'react-icons/fa'
import './Header.css'

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [isServicesOpen, setIsServicesOpen] = useState(false)
  const [isLocationsOpen, setIsLocationsOpen] = useState(false)

  const services = [
    { name: 'Hand & Wrist Care', slug: 'hand-wrist-care' },
    { name: 'Shoulder & Elbow Care', slug: 'shoulder-elbow' },
    { name: 'Lumbar & Cervical Spine Care', slug: 'lumbar-cervical-spine' },
    { name: 'Hip & Knee Care', slug: 'hip-knee-care' },
    { name: 'Foot & Ankle Care', slug: 'foot-ankle-care' },
    { name: 'Total Joint Replacement', slug: 'total-joint-replacement' },
    { name: 'Auto Injury', slug: 'auto-injury' },
    { name: 'Sports Medicine', slug: 'sports-medicine' }
  ]

  const locations = [
    { name: 'Los Angeles', slug: 'los-angeles' },
    { name: 'London', slug: 'london' },
    { name: 'Berlin', slug: 'berlin' }
  ]

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen)
  }

  return (
    <header className="header">
      <div className="header-top-bar">
        <div className="header-top-container">
          <div className="header-top-left">
            <Link to="/" className="logo-top">
              <span className="logo-text">Orthocare</span>
            </Link>
            <span className="top-tagline">Orthopedic Walk-In Clinic and #Teleorthopedics.</span>
          </div>
          <div className="header-top-right">
            <div className="top-location">
              <FaPhone className="phone-icon-top" />
              <div>
                <span className="location-name-top">Midland</span>
                <div className="phone-info">
                  <a href="tel:+14323228675">(432) 322-8675</a>
                  <span className="fax">Fax. (432) 218-7726</span>
                </div>
              </div>
            </div>
            <Link to="/book-appointment" className="btn-book-top">
              Book an Appointment →
            </Link>
          </div>
        </div>
      </div>
      
      <div className="header-container">
        <nav className={`nav ${isMenuOpen ? 'nav-open' : ''}`}>
          <button className="menu-toggle" onClick={toggleMenu}>
            {isMenuOpen ? <FaTimes /> : <FaBars />}
          </button>
          
          <ul className="nav-menu">
            <li><Link to="/" onClick={() => setIsMenuOpen(false)}>Home</Link></li>
            <li 
              className="nav-item-dropdown"
              onMouseEnter={() => setIsServicesOpen(true)}
              onMouseLeave={() => setIsServicesOpen(false)}
            >
              <span>Services ▾</span>
              {isServicesOpen && (
                <ul className="dropdown-menu">
                  {services.map((service) => (
                    <li key={service.slug}>
                      <Link 
                        to={`/services/${service.slug}`}
                        onClick={() => {
                          setIsMenuOpen(false)
                          setIsServicesOpen(false)
                        }}
                      >
                        {service.name}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </li>
            <li><Link to="/about" onClick={() => setIsMenuOpen(false)}>About</Link></li>
            <li><Link to="/workers-comp" onClick={() => setIsMenuOpen(false)}>Workers' Comp</Link></li>
            <li 
              className="nav-item-dropdown"
              onMouseEnter={() => setIsLocationsOpen(true)}
              onMouseLeave={() => setIsLocationsOpen(false)}
            >
              <span>Locations ▾</span>
              {isLocationsOpen && (
                <ul className="dropdown-menu">
                  {locations.map((location) => (
                    <li key={location.slug}>
                      <Link 
                        to={`/locations/${location.slug}`}
                        onClick={() => {
                          setIsMenuOpen(false)
                          setIsLocationsOpen(false)
                        }}
                      >
                        {location.name}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </li>
            <li><Link to="/blogs" onClick={() => setIsMenuOpen(false)}>Blogs</Link></li>
            <li><Link to="/contact-us" onClick={() => setIsMenuOpen(false)}>Contact Us</Link></li>
          </ul>
        </nav>
      </div>
    </header>
  )
}

export default Header

