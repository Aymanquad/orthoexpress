import React, { useEffect, useRef } from 'react'
import { useParams, Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaPhone, FaClock, FaCheckCircle, FaStethoscope, FaHospital } from 'react-icons/fa'
import './LocationDetail.css'

const LocationDetail = () => {
  const { locationName } = useParams()

  const locationsData = {
    'los-angeles': {
      name: 'Los Angeles',
      displayName: 'Los Angeles',
      address: '8500 Beverly Boulevard, Suite 450',
      city: 'Los Angeles, CA 90048',
      phone: '(323) 655-8450',
      hours: 'Mon - Fri: 9 am to 5 pm',
      heroImage: 'https://images.unsplash.com/photo-1516541196182-6bdb0516ed27?w=1920&h=800&fit=crop',
      contentImage: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&h=600&fit=crop',
      title: 'Orthopedic Urgent Care',
      description: 'Conveniently located in the heart of Los Angeles with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
      description2: 'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
      description3: 'Our Los Angeles facility features state-of-the-art diagnostic equipment and a dedicated team of orthopedic specialists. We offer comprehensive treatment options including non-surgical interventions, advanced surgical procedures, and personalized rehabilitation programs. Our clinic is equipped to handle everything from sports injuries to complex joint replacements, ensuring you receive the highest quality care in a comfortable, modern environment.',
      highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
      specialties: ['Advanced Sports Medicine', 'Joint Replacement', 'Spinal Surgery'],
      services: [
        'Emergency Orthopedic Care',
        'Sports Injury Treatment',
        'Joint Replacement Surgery',
        'Spinal Surgery & Treatment',
        'Physical Therapy & Rehabilitation',
        'X-Ray & Diagnostic Imaging',
        'Pain Management',
        'Workers Compensation Services'
      ],
      features: [
        'Same-Day Appointments Available',
        'Walk-In Urgent Care',
        'On-Site X-Ray Facilities',
        'Expert Orthopedic Surgeons',
        'Modern Surgical Suites',
        'Physical Therapy Center',
        'Ample Parking Available',
        'Wheelchair Accessible'
      ]
    },
    'london': {
      name: 'London',
      displayName: 'London',
      address: '123 Harley Street',
      city: 'London, UK W1G 6AX',
      phone: '+44 20 7935 5555',
      hours: 'Mon - Fri: 9 am to 5 pm',
      heroImage: 'https://images.unsplash.com/photo-1577906096421-f5e9a85c8cc6?w=1920&h=800&fit=crop',
      contentImage: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=800&h=600&fit=crop',
      title: 'Orthopedic Urgent Care',
      description: 'Conveniently located in the prestigious Harley Street medical district with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
      description2: 'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
      description3: 'Our Harley Street location represents the pinnacle of orthopedic excellence in London. With a reputation built on precision, innovation, and patient-centered care, our facility offers specialized services in hand and wrist surgery, orthopedic trauma management, and comprehensive rehabilitation. Our team of internationally recognized surgeons utilizes the latest techniques and technologies to deliver exceptional outcomes for our patients.',
      highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
      specialties: ['Hand & Wrist Surgery', 'Orthopedic Trauma Care', 'Rehabilitation Services'],
      services: [
        'Hand & Wrist Surgery',
        'Orthopedic Trauma Care',
        'Complex Fracture Management',
        'Microsurgery',
        'Rehabilitation Services',
        'Occupational Therapy',
        'Custom Splinting & Bracing',
        'Arthroscopic Procedures'
      ],
      features: [
        'Prestigious Harley Street Location',
        'Internationally Recognized Surgeons',
        'Advanced Surgical Facilities',
        'Comprehensive Rehabilitation Center',
        'Private Consultation Rooms',
        'Multilingual Staff',
        'International Patient Services',
        'Easy Transport Access'
      ]
    },
    'berlin': {
      name: 'Berlin',
      displayName: 'Berlin',
      address: 'Friedrichstraße 123',
      city: '10117 Berlin, Germany',
      phone: '+49 30 1234 5678',
      hours: 'Mon - Fri: 9 am to 5 pm',
      heroImage: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=1920&h=800&fit=crop',
      contentImage: 'https://images.unsplash.com/photo-1542281286-9e0a4bb2342b?w=800&h=600&fit=crop',
      title: 'Orthopedic Urgent Care',
      description: 'Conveniently located in central Berlin with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
      description2: 'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
      description3: 'Our Berlin clinic combines cutting-edge medical technology with a patient-first approach. Specializing in minimally invasive surgical techniques, hip and knee care, and comprehensive pain management, we serve both local and international patients. Our multilingual team ensures clear communication, and our modern facility is designed to provide a comfortable, efficient healthcare experience in the heart of Europe.',
      highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
      specialties: ['Minimally Invasive Surgery', 'Hip & Knee Care', 'Pain Management'],
      services: [
        'Minimally Invasive Surgery',
        'Hip & Knee Replacement',
        'Arthroscopic Surgery',
        'Pain Management & Injections',
        'Physical Therapy',
        'Sports Medicine',
        'Pediatric Orthopedics',
        'Geriatric Orthopedic Care'
      ],
      features: [
        'Central Berlin Location',
        'Minimally Invasive Techniques',
        'State-of-the-Art Operating Rooms',
        'Multilingual Medical Staff',
        'International Patient Coordination',
        'Comprehensive Pain Management',
        'Rehabilitation Services',
        'Public Transport Access'
      ]
    }
  }

  const location = locationsData[locationName] || {
    name: 'Location',
    displayName: 'Location',
    address: '',
    city: '',
    phone: '',
    hours: '',
    heroImage: '',
    contentImage: '',
    title: '',
    description: '',
    description2: '',
    description3: '',
    highlights: [],
    specialties: [],
    services: [],
    features: []
  }

  const renderDescription = (text, highlights) => {
    let result = text
    highlights.forEach(highlight => {
      const regex = new RegExp(`(${highlight})`, 'gi')
      result = result.replace(regex, `<strong>$1</strong>`)
    })
    return result
  }

  const sectionRefs = useRef([])

  useEffect(() => {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in')
        }
      })
    }, observerOptions)

    sectionRefs.current.forEach((section) => {
      if (section) observer.observe(section)
    })

    return () => {
      sectionRefs.current.forEach((section) => {
        if (section) observer.unobserve(section)
      })
    }
  }, [])

  return (
    <div className="location-detail-page">
      {/* Hero Section */}
      <section className="location-hero">
        <div className="location-hero-background">
          <img 
            src={location.heroImage} 
            alt={location.displayName}
            className="location-hero-image"
          />
          <div className="location-hero-overlay"></div>
        </div>
        <div className="container">
          <span className="location-hero-label">LOCATIONS</span>
          <h1 className="location-hero-title">{location.displayName}</h1>
        </div>
      </section>

      {/* Main Content Section */}
      <section className="location-content">
        <div className="container">
          <div 
            ref={(el) => (sectionRefs.current[0] = el)}
            className="location-main-layout animate-section"
          >
            {/* Left Side - Text Content */}
            <div className="location-text-content">
              <div className="label-badge">
                <FaHospital className="label-icon" />
                <span className="location-section-label">ORTHOCARE AT {location.displayName.toUpperCase()}</span>
              </div>
              <h2 className="location-main-title">{location.title}</h2>
              <div className="description-wrapper">
                <p 
                  className="location-description"
                  dangerouslySetInnerHTML={{ __html: renderDescription(location.description, location.highlights) }}
                />
                <p className="location-description-2">{location.description2}</p>
                {location.description3 && (
                  <p className="location-description-3">{location.description3}</p>
                )}
              </div>
            </div>

            {/* Right Side - Image */}
            <div className="location-image-content">
              <div className="image-wrapper">
                <img 
                  src={location.contentImage} 
                  alt={`Orthocare ${location.displayName}`}
                  className="location-content-image"
                />
                <div className="image-overlay"></div>
              </div>
            </div>
          </div>

          {/* Services & Features Section */}
          {(location.services && location.services.length > 0) || (location.features && location.features.length > 0) ? (
            <div 
              ref={(el) => (sectionRefs.current[1] = el)}
              className="location-services-features animate-section"
            >
              {location.services && location.services.length > 0 && (
                <div className="services-section modern-card">
                  <div className="section-header">
                    <FaStethoscope className="section-icon" />
                    <h3 className="section-heading">Our Services</h3>
                  </div>
                  <ul className="services-list">
                    {location.services.map((service, index) => (
                      <li key={index} className="service-item">
                        <FaCheckCircle className="check-icon" />
                        <span>{service}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
              {location.features && location.features.length > 0 && (
                <div className="features-section modern-card">
                  <div className="section-header">
                    <FaHospital className="section-icon" />
                    <h3 className="section-heading">Location Features</h3>
                  </div>
                  <ul className="features-list">
                    {location.features.map((feature, index) => (
                      <li key={index} className="feature-item">
                        <FaCheckCircle className="check-icon" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          ) : null}

          {/* Contact Cards Section */}
          <div 
            ref={(el) => (sectionRefs.current[2] = el)}
            className="location-contact-cards animate-section"
          >
            <div className="contact-card contact-card-1">
              <div className="contact-icon-wrapper">
                <FaMapMarkerAlt className="contact-icon" />
              </div>
              <p className="contact-text">{location.address}, {location.city}</p>
            </div>
            <div className="contact-card contact-card-2">
              <div className="contact-icon-wrapper">
                <FaPhone className="contact-icon" />
              </div>
              <p className="contact-text">{location.phone}</p>
            </div>
            <div className="contact-card contact-card-3">
              <div className="contact-icon-wrapper">
                <FaClock className="contact-icon" />
              </div>
              <p className="contact-text">{location.hours}</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default LocationDetail

