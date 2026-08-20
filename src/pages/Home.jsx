import React from 'react'
import WhatWeTreat from '../components/home/WhatWeTreat'
import PageMeta from '../components/PageMeta'
import Hero from '../components/home/Hero'
import HowWeCare from '../components/home/HowWeCare'
import SkeletonViewer from '../components/home/skeleton/SkeletonViewer'
import LocationsPreview from '../components/home/LocationsPreview'
import ReviewsBar from '../components/home/ReviewsBar'
import InsuranceBar from '../components/home/InsuranceBar'
import BlogPreview from '../components/home/BlogPreview'
import EhrIntegrations from '../components/home/EhrIntegrations'
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
      <SkeletonViewer />
      <LocationsPreview />
      <ReviewsBar />
      <InsuranceBar />
      <BlogPreview />
      <EhrIntegrations />
    </div>
  )
}

export default Home
