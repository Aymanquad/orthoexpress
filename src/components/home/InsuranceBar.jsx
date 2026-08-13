import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone } from 'react-icons/fa'
import { CLINIC } from '../../data'
import { toTelLink } from '../../data/utils'
import { useLanguage } from '../../context/LanguageContext'
import './InsuranceBar.css'

const InsuranceBar = () => {
  const { t } = useLanguage()
  const insuranceProviders = [
    'ACPN',
    'AvMed',
    'AETNA',
    'Molina',
    'Cigna',
    'United Healthcare',
    'Coventry',
    'Florida Blue',
    'Simply Healthcare',
    'Medicare Gov',
    'Medicaid Gov',
  ]

  return (
    <section className="insurance-bar section">
      <div className="container">
        <h2 className="insurance-title">{t('home.insurance.title')}</h2>
        <p className="insurance-subtitle">{t('home.insurance.subtitle')}</p>
        <p className="insurance-note-bold">
          <strong>{t('home.insurance.noInsurance')}</strong>
        </p>
        <div className="insurance-grid">
          {insuranceProviders.map((provider) => (
            <div key={provider} className="insurance-card">
              <p className="insurance-name">{provider}</p>
            </div>
          ))}
        </div>
        <div className="insurance-cta-row">
          <a href={toTelLink(CLINIC.headquarters.phone)} className="insurance-cta-call">
            <FaPhone /> {t('home.insurance.verify')} · {CLINIC.headquarters.phone}
          </a>
          <Link to="/payment" className="insurance-cta-link">
            {t('home.insurance.viewPricing')}
          </Link>
        </div>
      </div>
    </section>
  )
}

export default InsuranceBar
