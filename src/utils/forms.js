import { CLINIC } from '../data/clinic'
import { getLocationBySlug } from '../data/locations'

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const PHONE_PATTERN = /^[\d\s\-+().]{7,}$/

/** Formspree endpoint — set VITE_FORMSPREE_FORM_ID in .env (e.g. xnpapoda) */
const FORMSPREE_FORM_ID = import.meta.env.VITE_FORMSPREE_FORM_ID

export function validateContactForm(data, t) {
  const errors = {}

  if (!data.name?.trim()) {
    errors.name = t('forms.errors.nameRequired')
  }

  if (!data.email?.trim()) {
    errors.email = t('forms.errors.emailRequired')
  } else if (!EMAIL_PATTERN.test(data.email.trim())) {
    errors.email = t('forms.errors.emailInvalid')
  }

  if (data.phone?.trim() && !PHONE_PATTERN.test(data.phone.trim())) {
    errors.phone = t('forms.errors.phoneInvalid')
  }

  if (!data.message?.trim()) {
    errors.message = t('forms.errors.messageRequired')
  } else if (data.message.trim().length < 10) {
    errors.message = t('forms.errors.messageMinLength')
  }

  if (!data.consent) {
    errors.consent = t('forms.errors.consentRequired')
  }

  return errors
}

export function validateAppointmentForm(data, t) {
  const errors = {}

  if (!data.name?.trim()) {
    errors.name = t('forms.errors.fullNameRequired')
  }

  if (!data.phone?.trim()) {
    errors.phone = t('forms.errors.phoneRequired')
  } else if (!PHONE_PATTERN.test(data.phone.trim())) {
    errors.phone = t('forms.errors.phoneInvalid')
  }

  if (!data.email?.trim()) {
    errors.email = t('forms.errors.emailRequired')
  } else if (!EMAIL_PATTERN.test(data.email.trim())) {
    errors.email = t('forms.errors.emailInvalid')
  }

  if (!data.location) {
    errors.location = t('forms.errors.locationRequired')
  }

  if (!data.preferredDate) {
    errors.preferredDate = t('forms.errors.dateRequired')
  } else if (data.preferredDate < new Date().toISOString().split('T')[0]) {
    errors.preferredDate = t('forms.errors.datePast')
  }

  if (!data.consent) {
    errors.consent = t('forms.errors.consentRequired')
  }

  return errors
}

async function submitToFormspree(payload) {
  if (!FORMSPREE_FORM_ID) {
    throw new Error('Form endpoint is not configured.')
  }

  const response = await fetch(`https://formspree.io/f/${FORMSPREE_FORM_ID}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(payload),
  })

  const result = await response.json().catch(() => ({}))
  if (!response.ok) {
    throw new Error(result.error || 'Unable to send your request. Please try again.')
  }

  return { success: true }
}

function openMailto(subject, body) {
  window.location.href = `mailto:${CLINIC.email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`
}

export async function submitContactForm(data) {
  const payload = {
    _subject: `Contact form — ${data.name}`,
    formType: 'Contact Us',
    name: data.name,
    email: data.email,
    phone: data.phone || 'Not provided',
    message: data.message,
  }

  if (FORMSPREE_FORM_ID) {
    return submitToFormspree(payload)
  }

  openMailto(
    `Contact from ${data.name}`,
    `Name: ${data.name}\nEmail: ${data.email}\nPhone: ${data.phone || 'N/A'}\n\nMessage:\n${data.message}`
  )
  return { success: true, viaMailto: true }
}

export async function submitAppointmentForm(data) {
  const location = getLocationBySlug(data.location)
  const locationLabel = location ? `${location.name} — ${location.city}` : data.location

  const payload = {
    _subject: `Appointment request — ${data.name}`,
    formType: 'Book Appointment',
    name: data.name,
    email: data.email,
    phone: data.phone,
    location: locationLabel,
    preferredDate: data.preferredDate,
    preferredTime: data.preferredTime || 'No preference',
    reason: data.reason || 'Not provided',
  }

  if (FORMSPREE_FORM_ID) {
    return submitToFormspree(payload)
  }

  openMailto(
    `Appointment request from ${data.name}`,
    `Name: ${data.name}\nEmail: ${data.email}\nPhone: ${data.phone}\nLocation: ${locationLabel}\nPreferred Date: ${data.preferredDate}\nPreferred Time: ${data.preferredTime || 'No preference'}\n\nReason:\n${data.reason || 'Not provided'}`
  )
  return { success: true, viaMailto: true }
}
