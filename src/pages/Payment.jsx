import React, { useEffect, useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { FaPhone } from 'react-icons/fa'
import PageMeta from '../components/PageMeta'
import { CLINIC } from '../data'
import { INSURANCE_PROVIDERS, SELF_PAY_PRICING } from '../data/content'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const Payment = () => {
  const { t, lang } = useLanguage()
  const { hash } = useLocation()
  const [activeSection, setActiveSection] = useState('insurance')

  useEffect(() => {
    const next = hash === '#self-pay' ? 'self-pay' : 'insurance'
    setActiveSection(next)
  }, [hash])

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.payment.title')}
        description={t('pages.meta.payment.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('pages.info.paymentEyebrow')}</span>
          <h1 className="page-title">{t('pages.info.paymentTitle')}</h1>
          <p className="info-lead">{t('pages.info.paymentLead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-nav-pills">
            <a
              href="#insurance"
              className={activeSection === 'insurance' ? 'faq-pill-active' : ''}
            >
              {t('pages.info.insuranceHeading')}
            </a>
            <a
              href="#self-pay"
              className={activeSection === 'self-pay' ? 'faq-pill-active' : ''}
            >
              {t('pages.info.selfPayHeading')}
            </a>
          </div>

          <div id="insurance" className="info-block">
            <h2>{t('pages.info.insuranceHeading')}</h2>
            <p>{t('pages.info.insuranceLead')}</p>
            <div className="info-chip-grid">
              {INSURANCE_PROVIDERS.map((provider) => (
                <div key={provider} className="info-chip">
                  {provider}
                </div>
              ))}
            </div>
            <div className="info-actions">
              <a href={toTelLink(CLINIC.headquarters.phone)} className="btn btn-primary">
                <FaPhone aria-hidden="true" /> {t('common.call')} · {CLINIC.headquarters.phone}
              </a>
              <Link to="/contact-us" className="btn btn-outline">
                {t('common.contactUs')}
              </Link>
            </div>
          </div>

          <div id="self-pay" className="info-block">
            <h2>{t('pages.info.selfPayHeading')}</h2>
            <p>{t('pages.info.selfPayLead')}</p>
            <div className="info-price-list">
              {SELF_PAY_PRICING.map((item) => (
                <div key={item.id} className="info-price-row">
                  <div>
                    <h3>{item.name[lang] || item.name.en}</h3>
                    <p>{item.note[lang] || item.note.en}</p>
                  </div>
                  <strong>{item.price}</strong>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Payment
