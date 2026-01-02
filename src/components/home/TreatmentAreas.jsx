import React from 'react'
import { Link } from 'react-router-dom'
import './TreatmentAreas.css'

const TreatmentAreas = () => {
  const treatmentAreas = [
    {
      title: 'Expert Hand & Wrist Care',
      description: 'Common Hand & Wrist Conditions.',
      slug: 'hand-wrist-care',
      image: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600&h=400&fit=crop'
    },
    {
      title: 'Shoulder & Elbow Care',
      description: 'Common Shoulder & Elbow Conditions Treated.',
      slug: 'shoulder-elbow',
      image: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600&h=400&fit=crop'
    },
    {
      title: 'Cervical & Lumbar Spine Treatment',
      description: 'Common Lumbar & Cervical Spine Conditions Treated.',
      slug: 'lumbar-cervical-spine',
      image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&h=400&fit=crop'
    },
    {
      title: 'Hip & Knee Care',
      description: 'Common Hip & Knee Conditions Treated.',
      slug: 'hip-knee-care',
      image: 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=600&h=400&fit=crop'
    },
    {
      title: 'Foot & Ankle Care',
      description: "OrthoExpress's on-site foot and ankle specialists.",
      slug: 'foot-ankle-care',
      image: '/assets/knee-injury.webp'
    },
    {
      title: 'Total Joint Replacement',
      description: "If you're experiencing joint pain, stiffness, limited motion, and weakness, it can be difficult to live your best life.",
      slug: 'total-joint-replacement',
      image: 'https://images.unsplash.com/photo-1576678927484-cc907957088c?w=600&h=400&fit=crop'
    }
  ]

  return (
    <section className="treatment-areas section">
      <div className="container">
        <h2 className="section-title">Expert Care for All Your Orthopedic Needs</h2>
        <p className="section-subtitle">Treatment Areas</p>
        <div className="treatment-areas-grid">
          {treatmentAreas.map((area) => (
            <Link 
              key={area.slug} 
              to={`/services/${area.slug}`}
              className="treatment-area-card"
            >
              <div className="treatment-area-image-wrapper">
                <img 
                  src={area.image} 
                  alt={area.title}
                  className="treatment-area-image"
                  loading="lazy"
                />
                <div className="treatment-area-overlay"></div>
              </div>
              <div className="treatment-area-content">
                <h3 className="treatment-area-title">{area.title}</h3>
                <p className="treatment-area-description">{area.description}</p>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  )
}

export default TreatmentAreas

