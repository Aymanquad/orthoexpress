import React from 'react'
import { Link } from 'react-router-dom'
import './WorkersComp.css'

const WorkersComp = () => {
  return (
    <div className="workers-comp-page">
      <section className="workers-comp-hero section">
        <div className="container">
          <h1 className="page-title">Workers' Compensation Services</h1>
          <p className="page-subtitle">Expert Care for Work-Related Injuries</p>
        </div>
      </section>

      <section className="workers-comp-content section">
        <div className="container">
          <div className="content-section">
            <h2>Comprehensive Workers' Compensation Care</h2>
            <p>
              At Orthoexpress, we understand the unique challenges that come with 
              work-related injuries. Our experienced team specializes in providing 
              comprehensive orthopedic care for workers' compensation cases, ensuring 
              you receive the treatment you need to return to work safely and efficiently.
            </p>
          </div>

          <div className="content-section">
            <h2>Our Services</h2>
            <div className="services-list">
              <div className="service-item">
                <h3>Immediate Injury Assessment</h3>
                <p>Quick evaluation and diagnosis of work-related orthopedic injuries.</p>
              </div>
              <div className="service-item">
                <h3>Treatment Planning</h3>
                <p>Customized treatment plans designed to get you back to work safely.</p>
              </div>
              <div className="service-item">
                <h3>Documentation & Reporting</h3>
                <p>Complete documentation for your workers' compensation claim.</p>
              </div>
              <div className="service-item">
                <h3>Rehabilitation Services</h3>
                <p>Comprehensive rehabilitation to restore function and prevent re-injury.</p>
              </div>
            </div>
          </div>

          <div className="content-section">
            <h2>Why Choose Us for Workers' Comp</h2>
            <ul className="benefits-list">
              <li>Walk-in appointments available - no need to wait</li>
              <li>Experienced in workers' compensation protocols</li>
              <li>Direct communication with employers and insurance companies</li>
              <li>Focus on safe return to work</li>
              <li>Comprehensive documentation for claims</li>
            </ul>
          </div>

          <div className="cta-section">
            <Link to="/contact-us" className="btn btn-primary">
              Contact Us for Workers' Comp Services
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default WorkersComp

