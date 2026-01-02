import React, { useEffect, useRef } from 'react'
import Hero from '../components/home/Hero'
import ServicesSnapshot from '../components/home/ServicesSnapshot'
import ClinicServices from '../components/home/ClinicServices'
import LocationsPreview from '../components/home/LocationsPreview'
import TreatmentAreas from '../components/home/TreatmentAreas'
import Testimonials from '../components/home/Testimonials'
import Stats from '../components/home/Stats'
import InsuranceBar from '../components/home/InsuranceBar'
import BlogPreview from '../components/home/BlogPreview'
import './Home.css'

const Home = () => {
  const sectionsRef = useRef([])

  useEffect(() => {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -100px 0px'
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in')
        }
      })
    }, observerOptions)

    sectionsRef.current.forEach((section) => {
      if (section) observer.observe(section)
    })

    return () => {
      sectionsRef.current.forEach((section) => {
        if (section) observer.unobserve(section)
      })
    }
  }, [])

  return (
    <div className="home-page">
      <div ref={(el) => (sectionsRef.current[0] = el)} className="section-wrapper">
        <Hero />
      </div>
      <div ref={(el) => (sectionsRef.current[1] = el)} className="section-wrapper">
        <ServicesSnapshot />
      </div>
      <div ref={(el) => (sectionsRef.current[2] = el)} className="section-wrapper">
        <ClinicServices />
      </div>
      <div ref={(el) => (sectionsRef.current[3] = el)} className="section-wrapper">
        <LocationsPreview />
      </div>
      <div ref={(el) => (sectionsRef.current[4] = el)} className="section-wrapper">
        <TreatmentAreas />
      </div>
      <div ref={(el) => (sectionsRef.current[5] = el)} className="section-wrapper">
        <Testimonials />
      </div>
      <div ref={(el) => (sectionsRef.current[6] = el)} className="section-wrapper">
        <Stats />
      </div>
      <div ref={(el) => (sectionsRef.current[7] = el)} className="section-wrapper">
        <InsuranceBar />
      </div>
      <div ref={(el) => (sectionsRef.current[8] = el)} className="section-wrapper">
        <BlogPreview />
      </div>
    </div>
  )
}

export default Home

