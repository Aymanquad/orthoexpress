import React from 'react'
import { useParams, Link } from 'react-router-dom'
import './ServiceDetail.css'

const ServiceDetail = () => {
  const { serviceName } = useParams()

  const servicesData = {
    'hand-wrist-care': {
      title: 'Hand & Wrist Care',
      description: 'Comprehensive treatment for hand and wrist conditions and injuries.',
      image: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=1200&h=600&fit=crop',
      overview: 'Our expert hand and wrist specialists provide comprehensive care for a wide range of conditions affecting these critical joints. From common repetitive strain injuries to complex fractures, we offer both conservative and surgical treatment options to restore function and relieve pain.',
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
      ],
      additionalInfo: 'Hand and wrist injuries can significantly impact daily activities and quality of life. Our team uses advanced diagnostic tools and techniques to accurately assess your condition and develop a personalized treatment plan. We understand the importance of hand function in your daily life and work closely with you to achieve the best possible outcomes.'
    },
    'shoulder-elbow': {
      title: 'Shoulder & Elbow Care',
      description: 'Expert care for shoulder and elbow injuries and conditions.',
      image: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=1200&h=600&fit=crop',
      overview: 'Shoulder and elbow problems can severely limit your mobility and cause significant discomfort. Our orthopedic specialists are experienced in treating everything from sports injuries to age-related degenerative conditions. We utilize the latest surgical and non-surgical techniques to help you regain full function and return to your active lifestyle.',
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
      ],
      additionalInfo: 'The shoulder and elbow are complex joints that require specialized care. Whether you\'re an athlete dealing with a sports injury or someone experiencing age-related joint problems, our comprehensive approach ensures you receive the most effective treatment. We prioritize conservative management when possible, but are fully equipped to perform advanced surgical procedures when needed.'
    },
    'lumbar-cervical-spine': {
      title: 'Lumbar & Cervical Spine Care',
      description: 'Specialized treatment for back and neck conditions.',
      image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=1200&h=600&fit=crop',
      overview: 'Back and neck pain are among the most common reasons people seek medical care. Our spine specialists offer comprehensive evaluation and treatment for conditions affecting the cervical (neck) and lumbar (lower back) regions. We focus on identifying the root cause of your pain and providing effective, long-term solutions.',
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
      ],
      additionalInfo: 'Spine conditions can cause debilitating pain and significantly impact your quality of life. Our team uses advanced imaging and diagnostic techniques to accurately identify the source of your pain. We offer a full spectrum of treatment options, from conservative approaches like physical therapy and injections to minimally invasive surgical procedures that can provide lasting relief.'
    },
    'hip-knee-care': {
      title: 'Hip & Knee Care',
      description: 'Comprehensive care for hip and knee conditions.',
      image: 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=1200&h=600&fit=crop',
      overview: 'Hip and knee problems can make even simple activities like walking or climbing stairs painful and difficult. Our orthopedic specialists provide expert care for injuries, arthritis, and other conditions affecting these weight-bearing joints. We work with you to develop a treatment plan that addresses your specific needs and helps you maintain an active lifestyle.',
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
      ],
      additionalInfo: 'The hip and knee joints bear significant weight and stress throughout our lives, making them susceptible to injury and wear. Whether you\'re dealing with a sports injury, arthritis, or a traumatic fracture, our comprehensive approach ensures you receive appropriate care. From advanced arthroscopic procedures to joint replacement surgery, we utilize the latest techniques to restore function and reduce pain.'
    },
    'foot-ankle-care': {
      title: 'Foot & Ankle Care',
      description: 'Expert treatment for foot and ankle conditions.',
      image: '/assets/knee-injury.webp',
      overview: 'Your feet and ankles support your entire body, making them essential for mobility and daily function. Our foot and ankle specialists provide comprehensive care for a wide range of conditions, from common sprains to complex deformities. We understand that foot problems can significantly impact your quality of life and are committed to helping you stay active and pain-free.',
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
      ],
      additionalInfo: 'Foot and ankle conditions can develop from overuse, injury, or structural problems. Our specialists are skilled in both conservative treatments and surgical interventions. We often start with non-invasive approaches like custom orthotics, physical therapy, and medication. When surgery is necessary, we utilize minimally invasive techniques whenever possible to promote faster recovery and minimize discomfort.'
    },
    'total-joint-replacement': {
      title: 'Total Joint Replacement',
      description: 'Advanced joint replacement procedures for improved mobility.',
      image: 'https://images.unsplash.com/photo-1576678927484-cc907957088c?w=1200&h=600&fit=crop',
      overview: 'When conservative treatments no longer provide relief from severe joint pain, joint replacement surgery can restore function and dramatically improve quality of life. Our experienced surgeons perform hip, knee, and shoulder replacement procedures using the latest techniques and materials. We focus on personalized care and comprehensive rehabilitation to help you return to your favorite activities.',
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
      ],
      additionalInfo: 'Joint replacement surgery has advanced significantly in recent years, with new techniques and materials that improve outcomes and recovery times. Our surgeons use advanced imaging and planning tools to ensure precise placement of implants. We also emphasize comprehensive pre- and post-operative care, including physical therapy and pain management, to help you achieve the best possible results and return to your active lifestyle.'
    },
    'auto-injury': {
      title: 'Auto Injury Care',
      description: 'Specialized care for injuries sustained in automobile accidents.',
      image: 'https://images.unsplash.com/photo-1551076805-e1869033e561?w=1200&h=600&fit=crop',
      overview: 'Auto accidents can cause a wide range of orthopedic injuries, from minor sprains to serious fractures. Our team specializes in evaluating and treating accident-related injuries, working closely with insurance companies and legal representatives when necessary. We provide comprehensive documentation and coordinate care to ensure you receive the treatment you need while navigating the claims process.',
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
      ],
      additionalInfo: 'Auto accident injuries often require immediate attention and careful documentation. Our specialists are experienced in treating all types of motor vehicle accident injuries, from whiplash and soft tissue damage to fractures and spinal injuries. We understand the complexity of auto injury cases and work to ensure proper diagnosis, effective treatment, and thorough documentation for insurance and legal purposes.'
    },
    'sports-medicine': {
      title: 'Sports Medicine',
      description: 'Comprehensive care for athletes and active individuals.',
      image: 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=1200&h=600&fit=crop',
      overview: 'Whether you\'re a professional athlete or a weekend warrior, sports injuries can sideline you from the activities you love. Our sports medicine specialists understand the unique needs of active individuals and provide comprehensive care focused on rapid recovery and injury prevention. We work with athletes of all levels to get them back in the game safely and effectively.',
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
      ],
      additionalInfo: 'Sports medicine goes beyond just treating injuries—it\'s about optimizing performance and preventing future problems. Our approach includes comprehensive evaluation, personalized treatment plans, and guidance on training modifications. We utilize cutting-edge techniques like platelet-rich plasma (PRP) therapy and advanced rehabilitation protocols to help athletes recover faster and stronger. Our goal is not just to treat your injury, but to help you perform better than before.'
    }
  }

  const service = servicesData[serviceName] || {
    title: 'Service',
    description: 'Service description',
    image: '',
    overview: '',
    conditions: [],
    treatments: [],
    additionalInfo: ''
  }

  return (
    <div className="service-detail-page">
      <section className="service-hero section">
        <div className="service-hero-background">
          {service.image && (
            <img 
              src={service.image} 
              alt={service.title}
              className="service-hero-image"
            />
          )}
          <div className="service-hero-overlay"></div>
        </div>
        <div className="container">
          <Link to="/" className="back-link">← Back to Home</Link>
          <h1 className="page-title">{service.title}</h1>
          <p className="page-subtitle">{service.description}</p>
        </div>
      </section>

      <section className="service-content section">
        <div className="container">
          <div className="service-details">
            {service.overview && (
              <div className="service-section">
                <h2>About This Service</h2>
                <p className="service-overview">{service.overview}</p>
              </div>
            )}

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

            {service.additionalInfo && (
              <div className="service-section">
                <h2>Why Choose Our Care</h2>
                <p className="service-additional-info">{service.additionalInfo}</p>
              </div>
            )}

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

