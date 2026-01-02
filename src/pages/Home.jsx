import React from 'react'
import { Link } from 'react-router-dom'
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
  return (
    <div className="home-page">
      <Hero />
      <ServicesSnapshot />
      <ClinicServices />
      <LocationsPreview />
      <TreatmentAreas />
      <Testimonials />
      <Stats />
      <InsuranceBar />
      <BlogPreview />
    </div>
  )
}

export default Home

