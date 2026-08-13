import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaEnvelope, FaMapMarkerAlt, FaClock } from 'react-icons/fa'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { validateContactForm, submitContactForm } from '../utils/forms'
import { useFormModal } from '../hooks/useFormModal'
import { useLanguage } from '../context/LanguageContext'
import Modal from '../components/Modal'
import PageMeta from '../components/PageMeta'
import '../components/FormFeedback.css'
import './ContactUs.css'

const initialFormState = {
  name: '',
  email: '',
  phone: '',
  message: '',
  consent: false,
}

const ContactUs = () => {
  const { t } = useLanguage()
  const { headquarters, email, hours } = CLINIC
  const [formData, setFormData] = useState(initialFormState)
  const [errors, setErrors] = useState({})
  const [isSubmitting, setIsSubmitting] = useState(false)
  const { modal, closeModal, showSuccess, showError, showValidationErrors } = useFormModal()

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }))
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }))
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    const validationErrors = validateContactForm(formData, t)
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors)
      showValidationErrors(validationErrors, t('pages.modal.checkForm'))
      return
    }

    setErrors({})
    setIsSubmitting(true)

    try {
      const result = await submitContactForm(formData)
      setFormData(initialFormState)
      showSuccess(
        t('pages.contact.successTitle'),
        result.viaMailto ? t('pages.contact.successMailto') : t('pages.contact.successForm')
      )
    } catch (error) {
      showError(
        t('pages.contact.errorTitle'),
        error.message || t('pages.contact.errorMessage')
      )
    } finally {
      setIsSubmitting(false)
    }
  }

  const consentText = t('pages.contact.consent').replace('{clinic}', CLINIC.name)

  return (
    <div className="contact-us-page">
      <PageMeta
        title={t('pages.meta.contact.title')}
        description={t('pages.meta.contact.description')}
      />

      <Modal
        isOpen={modal.isOpen}
        onClose={closeModal}
        type={modal.type}
        title={modal.title}
        message={modal.message}
        primaryLabel={t('pages.contact.gotIt')}
      />

      <section className="contact-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.contact.title')}</h1>
          <p className="page-subtitle">{t('pages.contact.subtitle')}</p>
        </div>
      </section>

      <section className="contact-content section">
        <div className="container">
          <div className="contact-grid">
            <div className="contact-info">
              <h2>{t('pages.contact.getInTouch')}</h2>
              <p>{t('pages.contact.getInTouchText')}</p>

              <div className="contact-details">
                <div className="contact-detail-item">
                  <FaPhone className="contact-icon" />
                  <div>
                    <h3>{t('pages.contact.phone')}</h3>
                    <a href={toTelLink(headquarters.phone)}>{headquarters.phone}</a>
                    <p className="contact-fax">{t('pages.contact.fax')}: {headquarters.fax}</p>
                  </div>
                </div>

                <div className="contact-detail-item">
                  <FaEnvelope className="contact-icon" />
                  <div>
                    <h3>{t('pages.contact.email')}</h3>
                    <a href={`mailto:${email}`}>{email}</a>
                  </div>
                </div>

                <div className="contact-detail-item">
                  <FaMapMarkerAlt className="contact-icon" />
                  <div>
                    <h3>{t('pages.contact.headquarters')}</h3>
                    <p>
                      {headquarters.label}<br />
                      {headquarters.city}
                    </p>
                    <Link to="/locations" className="contact-locations-link">
                      {t('pages.contact.viewAllLocations')}
                    </Link>
                  </div>
                </div>

                <div className="contact-detail-item">
                  <FaClock className="contact-icon" />
                  <div>
                    <h3>{t('pages.contact.hours')}</h3>
                    <p>{hours.weekday}</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="contact-form-container">
              <h2>{t('pages.contact.sendMessage')}</h2>
              <p className="form-hint">{t('pages.contact.formHint')}</p>

              <form
                className={`contact-form ${isSubmitting ? 'form-submitting' : ''}`}
                onSubmit={handleSubmit}
                noValidate
              >
                <div className={`form-group ${errors.name ? 'has-error' : ''}`}>
                  <label htmlFor="name">{t('pages.book.fullName')} *</label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    autoComplete="name"
                  />
                  {errors.name && <span className="field-error">{errors.name}</span>}
                </div>

                <div className={`form-group ${errors.email ? 'has-error' : ''}`}>
                  <label htmlFor="email">{t('pages.contact.email')} *</label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    autoComplete="email"
                  />
                  {errors.email && <span className="field-error">{errors.email}</span>}
                </div>

                <div className={`form-group ${errors.phone ? 'has-error' : ''}`}>
                  <label htmlFor="phone">{t('pages.contact.phone')}</label>
                  <input
                    type="tel"
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    autoComplete="tel"
                  />
                  {errors.phone && <span className="field-error">{errors.phone}</span>}
                </div>

                <div className={`form-group ${errors.message ? 'has-error' : ''}`}>
                  <label htmlFor="message">{t('pages.contact.send').replace(/^(Send|Enviar)\s+/i, '')} *</label>
                  <textarea
                    id="message"
                    name="message"
                    rows="6"
                    value={formData.message}
                    onChange={handleChange}
                  />
                  {errors.message && <span className="field-error">{errors.message}</span>}
                </div>

                <div className={`form-group form-consent ${errors.consent ? 'has-error' : ''}`}>
                  <input
                    type="checkbox"
                    id="consent"
                    name="consent"
                    checked={formData.consent}
                    onChange={handleChange}
                  />
                  <label htmlFor="consent">
                    {consentText}{' '}
                    <Link to="/privacy-policy">{t('common.privacyPolicy')}</Link>.
                  </label>
                  {errors.consent && <span className="field-error">{errors.consent}</span>}
                </div>

                <button type="submit" className="btn btn-primary" disabled={isSubmitting}>
                  {isSubmitting ? t('pages.contact.sending') : t('pages.contact.send')}
                </button>
              </form>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default ContactUs
