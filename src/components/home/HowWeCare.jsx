import React from 'react'
import { Link } from 'react-router-dom'
import { FaArrowRight } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import { getServiceImage, IMAGES } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './HowWeCare.css'

const TILES = [
  {
    key: 'lawyers',
    to: '/lawyers',
    step: '00',
    image: IMAGES.home.lawyers,
  },
  { key: 'diagnose', slug: 'mri-digital-imaging', to: '/services/mri-digital-imaging', step: '01' },
  { key: 'treat', slug: 'pain-inflammation', to: '/services/pain-inflammation', step: '02' },
  { key: 'surgery', slug: 'total-joint-replacement', to: '/services/total-joint-replacement', step: '03' },
  { key: 'recover', slug: 'sports-medicine', to: '/services/sports-medicine', step: '04' },
]

const HowWeCare = () => {
  const { t } = useLanguage()

  return (
    <section className="how-we-care section">
      <div className="container">
        <div className="how-we-care-header">
          <h2 className="how-we-care-title">{t('home.howWeCare.title')}</h2>
          <p className="how-we-care-subtitle">{t('home.howWeCare.subtitle')}</p>
        </div>
        <div className="how-we-care-grid">
          {TILES.map((tile) => {
            const img = tile.image || getServiceImage(tile.slug)
            return (
              <Link key={tile.key} to={tile.to} className="how-we-care-card">
                <div className="how-we-care-card-media">
                  <ImageWithFallback
                    src={img.src}
                    fallback={img.fallback}
                    alt=""
                    className="how-we-care-card-img"
                    style={tile.key === 'lawyers' ? { objectPosition: 'center 20%' } : undefined}
                  />
                  <span className="how-we-care-step">{tile.step}</span>
                </div>
                <div className="how-we-care-card-body">
                  <h3>{t(`home.howWeCare.tiles.${tile.key}.title`)}</h3>
                  <p>{t(`home.howWeCare.tiles.${tile.key}.desc`)}</p>
                  <span className="how-we-care-link">
                    {t('common.learnMore')} <FaArrowRight aria-hidden="true" />
                  </span>
                </div>
              </Link>
            )
          })}
        </div>
      </div>
    </section>
  )
}

export default HowWeCare
