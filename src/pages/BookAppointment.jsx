import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import { FaCalendarAlt, FaClock, FaUser, FaPhone, FaEnvelope } from 'react-icons/fa'
import { CLINIC, LOCATIONS } from '../data'
import { getTodayDateString } from '../data/utils'
import { validateAppointmentForm, submitAppointmentForm } from '../utils/forms'
import { useFormModal } from '../hooks/useFormModal'
import { useLanguage } from '../context/LanguageContext'
import Modal from '../components/Modal'
import PageMeta from '../components/PageMeta'
import '../components/FormFeedback.css'
import './BookAppointment.css'

const initialFormState = {
  name: '',
  email: '',
  phone: '',
  preferredDate: '',
  preferredTime: '',
  reason: '',
  location: '',
  consent: false,
}

const BookAppointment = () => {
  const { t } = useLanguage()
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

    const validationErrors = validateAppointmentForm(formData, t)
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors)
      showValidationErrors(validationErrors, t('pages.modal.checkForm'))
      return
    }

    setErrors({})
    setIsSubmitting(true)

    try {
      const result = await submitAppointmentForm(formData)
      setFormData(initialFormState)
      showSuccess(
        t('pages.book.successTitle'),
        result.viaMailto ? t('pages.book.successMailto') : t('pages.book.successForm')
      )
    } catch (error) {
      showError(
        t('pages.book.errorTitle'),
        error.message || t('forms.errors.submitFailed')
      )
    } finally {
      setIsSubmitting(false)
    }
  }

  const consentText = t('pages.book.consent').replace('{clinic}', CLINIC.name)

  return (
    <div className="book-appointment-page">
      <PageMeta
        title={t('pages.meta.book.title')}
        description={t('pages.meta.book.description')}
      />

      <Modal
        isOpen={modal.isOpen}
        onClose={closeModal}
        type={modal.type}
        title={modal.title}
        message={modal.message}
        primaryLabel={t('pages.contact.gotIt')}
      />

      <section className="appointment-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.book.title')}</h1>
          <p className="page-subtitle">{t('pages.book.subtitle')}</p>
        </div>
      </section>

      <section className="appointment-content section">
        <div className="container">
            <div className="appointment-info">
            <h2>{t('pages.book.title')}</h2>
            <p>{t('pages.book.subtitle')}</p>
            <p>{t('pages.book.formHint')}</p>
            <div className="info-cards">
              <div className="info-card">
                <FaClock className="info-icon" />
                <h3>{t('pages.about.feature1Title')}</h3>
                <p>{t('pages.about.feature1Text')}</p>
              </div>
              <div className="info-card">
                <FaCalendarAlt className="info-icon" />
                <h3>{t('pages.book.preferredTime')}</h3>
                <p>{t('pages.book.noPreference')}</p>
              </div>
            </div>
          </div>

          <div className="appointment-form-container">
            <h2>{t('pages.book.formTitle')}</h2>
            <p className="form-subtitle">{t('pages.book.formHint')}</p>

            <form
              className={`appointment-form ${isSubmitting ? 'form-submitting' : ''}`}
              onSubmit={handleSubmit}
              noValidate
            >
              <div className="form-row">
                <div className={`form-group ${errors.name ? 'has-error' : ''}`}>
                  <label htmlFor="name">
                    <FaUser /> {t('pages.book.fullName')} *
                  </label>
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

                <div className={`form-group ${errors.phone ? 'has-error' : ''}`}>
                  <label htmlFor="phone">
                    <FaPhone /> {t('pages.book.phone')} *
                  </label>
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
              </div>

              <div className="form-row">
                <div className={`form-group ${errors.email ? 'has-error' : ''}`}>
                  <label htmlFor="email">
                    <FaEnvelope /> {t('pages.book.email')} *
                  </label>
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

                <div className={`form-group ${errors.location ? 'has-error' : ''}`}>
                  <label htmlFor="location">{t('pages.book.location')} *</label>
                  <select
                    id="location"
                    name="location"
                    value={formData.location}
                    onChange={handleChange}
                  >
                    <option value="">{t('pages.book.selectLocation')}</option>
                    {LOCATIONS.map((loc) => (
                      <option key={loc.slug} value={loc.slug}>
                        {loc.name} — {loc.city}
                      </option>
                    ))}
                  </select>
                  {errors.location && <span className="field-error">{errors.location}</span>}
                </div>
              </div>

              <div className="form-row">
                <div className={`form-group ${errors.preferredDate ? 'has-error' : ''}`}>
                  <label htmlFor="preferredDate">{t('pages.book.preferredDate')} *</label>
                  <input
                    type="date"
                    id="preferredDate"
                    name="preferredDate"
                    value={formData.preferredDate}
                    onChange={handleChange}
                    min={getTodayDateString()}
                  />
                  {errors.preferredDate && <span className="field-error">{errors.preferredDate}</span>}
                </div>

                <div className="form-group">
                  <label htmlFor="preferredTime">{t('pages.book.preferredTime')}</label>
                  <select
                    id="preferredTime"
                    name="preferredTime"
                    value={formData.preferredTime}
                    onChange={handleChange}
                  >
                    <option value="">{t('pages.book.noPreference')}</option>
                    <option value="morning">{t('pages.book.morning')}</option>
                    <option value="afternoon">{t('pages.book.afternoon')}</option>
                    <option value="evening">{t('pages.book.lateAfternoon')}</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="reason">{t('pages.book.reason')}</label>
                <textarea
                  id="reason"
                  name="reason"
                  rows="4"
                  value={formData.reason}
                  onChange={handleChange}
                  placeholder={t('pages.book.reasonPlaceholder')}
                />
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

              <button type="submit" className="btn btn-primary btn-large" disabled={isSubmitting}>
                {isSubmitting ? t('pages.book.submitting') : t('pages.book.submit')}
              </button>
            </form>
          </div>
        </div>
      </section>
    </div>
  )
}

export default BookAppointment
