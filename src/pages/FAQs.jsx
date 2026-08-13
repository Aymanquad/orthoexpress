import React, { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { FAQS } from '../data/content'
import { FAQ_SPECIALTIES } from '../data/patientCare'
import { getServicePath } from '../data/services'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const SERVICE_SLUGS = new Set(
  FAQ_SPECIALTIES.map((s) => s.id).filter(
    (id) => id !== 'all' && id !== 'general' && id !== 'telehealth' && id !== 'workers-comp'
  )
)

function getFaqRelatedPath(specialty) {
  if (specialty === 'workers-comp') return '/workers-comp'
  if (specialty === 'telehealth') return '/telehealth'
  if (SERVICE_SLUGS.has(specialty)) return getServicePath({ slug: specialty })
  return null
}

const FAQs = () => {
  const { t, lang } = useLanguage()
  const [openId, setOpenId] = useState(FAQS[0]?.id || null)
  const [specialty, setSpecialty] = useState('all')

  const filteredFaqs = useMemo(() => {
    if (specialty === 'all') return FAQS
    return FAQS.filter((faq) => faq.specialty === specialty)
  }, [specialty])

  const categories = useMemo(() => {
    const set = new Set(filteredFaqs.map((f) => f.category[lang] || f.category.en))
    return Array.from(set)
  }, [filteredFaqs, lang])

  const handleSpecialtyChange = (next) => {
    setSpecialty(next)
    const nextFaqs = next === 'all' ? FAQS : FAQS.filter((f) => f.specialty === next)
    setOpenId(nextFaqs[0]?.id || null)
  }

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.faqs.title')}
        description={t('pages.meta.faqs.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('pages.info.help')}</span>
          <h1 className="page-title">{t('pages.info.faqsTitle')}</h1>
          <p className="info-lead">{t('pages.info.faqsLead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container info-narrow">
          <div className="faq-specialty-filter">
            <p className="faq-specialty-label" id="faq-specialty-label">
              {t('patientCare.faqs.filterLabel')}
            </p>
            <div className="info-nav-pills" role="tablist" aria-labelledby="faq-specialty-label">
              {FAQ_SPECIALTIES.map((item) => (
                <button
                  key={item.id}
                  type="button"
                  role="tab"
                  aria-selected={specialty === item.id}
                  className={specialty === item.id ? 'faq-pill-active' : ''}
                  onClick={() => handleSpecialtyChange(item.id)}
                >
                  {item.label[lang] || item.label.en}
                </button>
              ))}
            </div>
          </div>

          {filteredFaqs.length === 0 ? (
            <p className="faq-empty">{t('patientCare.faqs.noMatch')}</p>
          ) : (
            categories.map((category) => (
              <div key={category} className="info-block">
                <h2>{category}</h2>
                <div className="faq-list">
                  {filteredFaqs
                    .filter((f) => (f.category[lang] || f.category.en) === category)
                    .map((faq) => {
                      const open = openId === faq.id
                      const servicePath = getFaqRelatedPath(faq.specialty)

                      return (
                        <div key={faq.id} className={`faq-item ${open ? 'open' : ''}`}>
                          <button
                            type="button"
                            className="faq-question"
                            aria-expanded={open}
                            onClick={() => setOpenId(open ? null : faq.id)}
                          >
                            <span>{faq.q[lang] || faq.q.en}</span>
                            <span className="faq-icon" aria-hidden="true">
                              {open ? '−' : '+'}
                            </span>
                          </button>
                          {open && (
                            <div className="faq-answer-wrap">
                              <p className="faq-answer">{faq.a[lang] || faq.a.en}</p>
                              {servicePath && (
                                <Link to={servicePath} className="faq-service-link">
                                  {t('patientCare.faqs.serviceLink')} →
                                </Link>
                              )}
                            </div>
                          )}
                        </div>
                      )
                    })}
                </div>
              </div>
            ))
          )}

          <div className="info-actions">
            <Link to="/contact-us" className="btn btn-primary">
              {t('common.contactUs')}
            </Link>
            <Link to="/book-appointment" className="btn btn-outline">
              {t('common.bookAppointment')}
            </Link>
            <Link to="/telehealth" className="btn btn-outline">
              {t('nav.telehealth')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default FAQs
