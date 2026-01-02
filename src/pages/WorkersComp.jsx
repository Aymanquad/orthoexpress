import React from 'react'
import { Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaArrowRight } from 'react-icons/fa'
import './WorkersComp.css'

const WorkersComp = () => {
  const locations = [
    'Lancaster',
    'Farmers Branch',
    'Midland',
    'Waxahachie'
  ]

  return (
    <div className="workers-comp-page">
      {/* Hero Section with Background Image */}
      <section className="workers-comp-hero">
        <div className="workers-comp-hero-background">
          <img 
            src="https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=1920&h=800&fit=crop" 
            alt="Worker with safety equipment"
            className="workers-comp-hero-image"
          />
          <div className="workers-comp-hero-overlay"></div>
        </div>
      </section>

      {/* Main Content Section */}
      <section className="workers-comp-content section">
        <div className="workers-comp-container">
          {/* Main Content Column */}
          <div className="workers-comp-main">
            <div className="workers-comp-intro">
              <p className="intro-text">
                With our workers' compensation and injury care services, your employees get convenient access to high-quality care at a lower cost and in an appropriate setting.
              </p>
              <p className="intro-text highlight">
                Better care for employees. Better savings for companies. Employees love our responsive, personalized care. You'll love the reduced care costs we make possible.
              </p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">Experienced Orthopedic Clinicians</h3>
              <p className="section-text">
                Orthopedic clinicians are available on demand when you need them.
              </p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">Comprehensive Treatment</h3>
              <p className="section-text">
                On-site treatment strategies include advanced diagnostics, treatment and injection therapy for immediate or chronic workplace problems.
              </p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">Medication Management</h3>
              <p className="section-text">
                Doctors at OrthoExpress clinics can prescribe medications to help manage pain, inflammation, and other symptoms associated with your work injury.
              </p>
            </div>

            <div className="workers-comp-section">
              <h3 className="section-heading">Patient Education</h3>
              <p className="section-text">
                The clinic can provide you with educational resources on your specific work-related <strong>injury</strong> or <strong>illness</strong>, including tips on preventing future injuries and how to manage your condition effectively.
              </p>
            </div>
          </div>

          {/* Sidebar Column */}
          <aside className="workers-comp-sidebar">
            <div className="locations-card">
              <h4 className="locations-card-title">OrthoExpress Locations</h4>
              <ul className="locations-list">
                {locations.map((location, index) => (
                  <li key={index} className="location-item">
                    <FaMapMarkerAlt className="location-icon" />
                    <span className="location-name">{location}</span>
                    <FaArrowRight className="location-arrow" />
                  </li>
                ))}
              </ul>
            </div>
          </aside>
        </div>
      </section>
    </div>
  )
}

export default WorkersComp

