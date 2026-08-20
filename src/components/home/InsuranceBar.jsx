import React from 'react'
import { Link } from 'react-router-dom'
import { useLanguage } from '../../context/LanguageContext'
import './InsuranceBar.css'

const TOP_PROVIDERS = [
  'AETNA',
  'Cigna',
  'United Healthcare',
  'Florida Blue',
  'Medicare Gov',
  'Medicaid Gov',
]

const InsuranceBar = () => {
  const { t } = useLanguage()

  return (
    <section className="insurance-bar section">
      <div className="container insurance-bar-inner">
        <div className="insurance-bar-copy">
          <h2 className="insurance-title">{t('home.insurance.title')}</h2>
          <p className="insurance-subtitle">{t('home.insurance.subtitle')}</p>
          <p className="insurance-note-bold">
            <strong>{t('home.insurance.noInsurance')}</strong>
          </p>
        </div>
        <div className="insurance-providers">
          {TOP_PROVIDERS.map((provider) => (
            <span key={provider} className="insurance-pill">
              {provider}
            </span>
          ))}
          <span className="insurance-pill insurance-pill--more">{t('home.insurance.andMore')}</span>
        </div>
        <div className="insurance-cta-row">
          <Link to="/payment" className="insurance-cta-link">
            {t('home.insurance.viewPricing')}
          </Link>
        </div>
      </div>
    </section>
  )
}

export default InsuranceBar
