import React from 'react'
import { useParams, Link } from 'react-router-dom'
import './ServiceDetail.css'

const ServiceDetail = () => {
  const { serviceName } = useParams()

  const servicesData = {
    'hand-wrist-care': {
      title: 'Hand & Wrist Care',
      description: 'Comprehensive treatment for hand and wrist conditions and injuries.',
      conditions: [
        'Carpal Tunnel Syndrome',
        'Wrist Fractures',
        'Tendon Injuries',
        'Arthritis',
        'Trigger Finger',
        'Ganglion Cysts'
      ],
      treatments: [
        'Non-surgical treatments including splinting and therapy',
        'Minimally invasive procedures',
        'Surgical reconstruction when needed',
        'Rehabilitation and recovery programs'
      ]
    },
    'shoulder-elbow': {
      title: 'Shoulder & Elbow Care',
      description: 'Expert care for shoulder and elbow injuries and conditions.',
      conditions: [
        'Rotator Cuff Tears',
        'Shoulder Dislocations',
        'Tennis Elbow',
        'Frozen Shoulder',
        'Bursitis',
        'Arthritis'
      ],
      treatments: [
        'Physical therapy and rehabilitation',
        'Cortisone injections',
        'Arthroscopic surgery',
        'Joint replacement when necessary'
      ]
    },
    'lumbar-cervical-spine': {
      title: 'Lumbar & Cervical Spine Care',
      description: 'Specialized treatment for back and neck conditions.',
      conditions: [
        'Herniated Discs',
        'Spinal Stenosis',
        'Sciatica',
        'Neck Pain',
        'Scoliosis',
        'Degenerative Disc Disease'
      ],
      treatments: [
        'Physical therapy',
        'Pain management injections',
        'Minimally invasive procedures',
        'Spinal fusion surgery when needed'
      ]
    },
    'hip-knee-care': {
      title: 'Hip & Knee Care',
      description: 'Comprehensive care for hip and knee conditions.',
      conditions: [
        'Osteoarthritis',
        'ACL Tears',
        'Meniscus Injuries',
        'Hip Fractures',
        'Bursitis',
        'Tendonitis'
      ],
      treatments: [
        'Conservative management',
        'Arthroscopic surgery',
        'Joint replacement',
        'Rehabilitation programs'
      ]
    },
    'foot-ankle-care': {
      title: 'Foot & Ankle Care',
      description: 'Expert treatment for foot and ankle conditions.',
      conditions: [
        'Ankle Sprains',
        'Plantar Fasciitis',
        'Achilles Tendon Injuries',
        'Bunions',
        'Stress Fractures',
        'Arthritis'
      ],
      treatments: [
        'Custom orthotics',
        'Physical therapy',
        'Minimally invasive procedures',
        'Surgical correction when needed'
      ]
    },
    'total-joint-replacement': {
      title: 'Total Joint Replacement',
      description: 'Advanced joint replacement procedures for improved mobility.',
      conditions: [
        'Severe Arthritis',
        'Joint Degeneration',
        'Failed Previous Surgeries',
        'Traumatic Joint Damage'
      ],
      treatments: [
        'Hip Replacement',
        'Knee Replacement',
        'Shoulder Replacement',
        'Comprehensive rehabilitation'
      ]
    },
    'auto-injury': {
      title: 'Auto Injury Care',
      description: 'Specialized care for injuries sustained in automobile accidents.',
      conditions: [
        'Whiplash',
        'Back Injuries',
        'Neck Injuries',
        'Fractures',
        'Soft Tissue Injuries'
      ],
      treatments: [
        'Immediate evaluation and diagnosis',
        'Pain management',
        'Physical therapy',
        'Surgical intervention when needed'
      ]
    },
    'sports-medicine': {
      title: 'Sports Medicine',
      description: 'Comprehensive care for athletes and active individuals.',
      conditions: [
        'Sports-related Fractures',
        'Ligament Tears',
        'Muscle Strains',
        'Overuse Injuries',
        'Concussions',
        'Performance Issues'
      ],
      treatments: [
        'Injury prevention programs',
        'Performance optimization',
        'Rapid recovery protocols',
        'Return-to-play assessments'
      ]
    }
  }

  const service = servicesData[serviceName] || {
    title: 'Service',
    description: 'Service description',
    conditions: [],
    treatments: []
  }

  return (
    <div className="service-detail-page">
      <section className="service-hero section">
        <div className="container">
          <Link to="/" className="back-link">← Back to Home</Link>
          <h1 className="page-title">{service.title}</h1>
          <p className="page-subtitle">{service.description}</p>
        </div>
      </section>

      <section className="service-content section">
        <div className="container">
          <div className="service-details">
            <div className="service-section">
              <h2>Common Conditions We Treat</h2>
              <ul className="conditions-list">
                {service.conditions.map((condition, index) => (
                  <li key={index}>{condition}</li>
                ))}
              </ul>
            </div>

            <div className="service-section">
              <h2>Treatment Options</h2>
              <ul className="treatments-list">
                {service.treatments.map((treatment, index) => (
                  <li key={index}>{treatment}</li>
                ))}
              </ul>
            </div>

            <div className="service-cta">
              <Link to="/book-appointment" className="btn btn-primary">
                Book an Appointment
              </Link>
              <Link to="/contact-us" className="btn btn-outline">
                Contact Us
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default ServiceDetail

