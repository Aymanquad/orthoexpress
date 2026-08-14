import React from 'react'
import WhatWeTreat from '../components/home/WhatWeTreat'
import PageMeta from '../components/PageMeta'
import Hero from '../components/home/Hero'
import HowWeCare from '../components/home/HowWeCare'
import LocationsPreview from '../components/home/LocationsPreview'
import ReviewsBar from '../components/home/ReviewsBar'
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
      <HowWeCare />
      <LocationsPreview />
      <ReviewsBar />
      <InsuranceBar />
      <BlogPreview />
    </div>
  )
}

export default Home
