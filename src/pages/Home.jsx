import React from 'react'
import WhatWeTreat from '../components/home/WhatWeTreat'
import PageMeta from '../components/PageMeta'
import Hero from '../components/home/Hero'
import ServicesSnapshot from '../components/home/ServicesSnapshot'
import ClinicServices from '../components/home/ClinicServices'
import LocationsPreview from '../components/home/LocationsPreview'
import TreatmentAreas from '../components/home/TreatmentAreas'
import ReviewsBar from '../components/home/ReviewsBar'
import Testimonials from '../components/home/Testimonials'
import Stats from '../components/home/Stats'
import InsuranceBar from '../components/home/InsuranceBar'
import BlogPreview from '../components/home/BlogPreview'
import { useLanguage } from '../context/LanguageContext'
import './Home.css'

const Home = () => {
  const { t } = useLanguage()

  return (
    <div className="home-page">
      <PageMeta
        title={t('pages.meta.home.title')}
        description={t('pages.meta.home.description')}
      />
      <Hero />
      <WhatWeTreat />
      <ServicesSnapshot />
      <ClinicServices />
      <LocationsPreview />
      <TreatmentAreas />
      <ReviewsBar />
      <Testimonials />
      <Stats />
      <InsuranceBar />
      <BlogPreview />
    </div>
  )
}

export default Home
