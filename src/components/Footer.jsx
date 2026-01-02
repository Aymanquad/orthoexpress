import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaEnvelope, FaMapMarkerAlt, FaFacebook, FaTwitter, FaLinkedin, FaInstagram } from 'react-icons/fa'
import './Footer.css'

const Footer = () => {
  const services = [
    { name: 'Hand & Wrist Care', slug: 'hand-wrist-care' },
    { name: 'Shoulder & Elbow', slug: 'shoulder-elbow' },
    { name: 'Lumbar & Cervical Spine', slug: 'lumbar-cervical-spine' },
    { name: 'Hip & Knee Care', slug: 'hip-knee-care' },
    { name: 'Foot & Ankle Care', slug: 'foot-ankle-care' },
    { name: 'Total Joint Replacement', slug: 'total-joint-replacement' },
    { name: 'Auto Injury', slug: 'auto-injury' },
    { name: 'Sports Medicine', slug: 'sports-medicine' }
  ]

  return (
    <footer className="footer">
      <div className="footer-container">
        <div className="footer-content">
          <div className="footer-section">
            <h3>OrthoExpress</h3>
            <p className="footer-tagline">Expert Orthopedic Care</p>
            <p>Walk-in, same day appointments available. Providing comprehensive orthopedic services with personalized patient care.</p>
            <div className="social-links">
              <a href="#" aria-label="Facebook"><FaFacebook /></a>
              <a href="#" aria-label="Twitter"><FaTwitter /></a>
              <a href="#" aria-label="LinkedIn"><FaLinkedin /></a>
              <a href="#" aria-label="Instagram"><FaInstagram /></a>
            </div>
          </div>

          <div className="footer-section">
            <h4>Quick Links</h4>
            <ul>
              <li><Link to="/">Home</Link></li>
              <li><Link to="/about">About Us</Link></li>
              <li><Link to="/workers-comp">Workers' Comp</Link></li>
              <li><Link to="/locations">Locations</Link></li>
              <li><Link to="/blogs">Blogs</Link></li>
              <li><Link to="/contact-us">Contact Us</Link></li>
            </ul>
          </div>

          <div className="footer-section">
            <h4>Services</h4>
            <ul>
              {services.map((service) => (
                <li key={service.slug}>
                  <Link to={`/services/${service.slug}`}>{service.name}</Link>
                </li>
              ))}
            </ul>
          </div>

          <div className="footer-section">
            <h4>Contact Info</h4>
            <ul className="contact-info">
              <li>
                <FaPhone /> <a href="tel:+1234567890">(123) 456-7890</a>
              </li>
              <li>
                <FaEnvelope /> <a href="mailto:info@orthoexpress.com">info@orthoexpress.com</a>
              </li>
              <li>
                <FaMapMarkerAlt /> 123 Medical Center Dr, City, State 12345
              </li>
            </ul>
            <Link to="/book-appointment" className="btn-footer-appointment">
              Book an Appointment
            </Link>
          </div>
        </div>

        <div className="footer-bottom">
          <p>&copy; {new Date().getFullYear()} OrthoExpress. All rights reserved.</p>
          <div className="footer-links">
            <Link to="/privacy-policy">Privacy Policy</Link>
            <span>|</span>
            <Link to="/terms">Terms of Service</Link>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer

