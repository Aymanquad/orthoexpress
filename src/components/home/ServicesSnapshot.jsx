import React from 'react'
import { Link } from 'react-router-dom'
import './ServicesSnapshot.css'

const ServicesSnapshot = () => {
  return (
    <section className="services-snapshot section">
      <div className="container">
        <div className="services-header">
          <span className="services-label">ORTHOPEDICS SERVICES</span>
          <h2 className="section-title">Get the expert care you deserve.</h2>
          <p className="services-description">
            Our <span className="highlight">Orthopedics Services</span> focus on addressing injuries and diseases that affect the musculoskeletal system — all the bones, joints, ligaments, tendons, muscles, and nerves that keep your body moving.
          </p>
          <p className="services-description">
            When something goes wrong with your muscles, joints, or bones, pain is often a symptom. Our expert team of <span className="highlight">orthopedic surgeons</span>, nurses, and other health professionals are dedicated to helping you heal.
          </p>
        </div>
        
        <div className="no-appointment-banner">
          <h3>Orthocare accepts walk-ins</h3>
          <h2>NO APPOINTMENT NECESSARY!</h2>
        </div>

        <div className="special-services">
          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <img 
                src="https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=600&h=400&fit=crop" 
                alt="Auto Injury Treatment"
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>Auto Injury</h3>
              <p>We offers professional medical attention for car accident victims, including trained orthopedic, spine, and neuro-spine surgeons.</p>
              <Link to="/services/auto-injury" className="know-more-link">Know More →</Link>
            </div>
          </div>

          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <img 
                src="https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600&h=400&fit=crop" 
                alt="Sports Medicine"
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>Sports Medicine</h3>
              <p>Most sports injuries are a result of minor trauma to muscles, ligaments, and/or tendons.</p>
              <Link to="/services/sports-medicine" className="know-more-link">Know More →</Link>
            </div>
          </div>

          <div className="special-service-card">
            <div className="special-service-image-wrapper">
              <img 
                src="https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=600&h=400&fit=crop" 
                alt="Workers Compensation"
                className="special-service-image"
                loading="lazy"
              />
            </div>
            <div className="special-service-content">
              <h3>Worker's compensation</h3>
              <p>With our workers' compensation and injury care services, your employees get convenient access to high-quality care at a lower cost and in an appropriate setting.</p>
              <Link to="/workers-comp" className="know-more-link">Know More →</Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default ServicesSnapshot

