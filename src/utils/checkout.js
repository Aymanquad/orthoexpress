const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const PHONE_PATTERN = /^[\d\s\-+().]{7,}$/
const POSTAL_PATTERN = /^[A-Za-z0-9][A-Za-z0-9\s-]{2,11}[A-Za-z0-9]$/

export const SHIPPING_RATE = 5.99
export const TAX_RATE = 0.08

export function calculateOrderTotals(subtotal) {
  const shipping = subtotal > 0 ? SHIPPING_RATE : 0
  const tax = subtotal * TAX_RATE
  const total = subtotal + shipping + tax

  return {
    subtotal,
    shipping,
    tax,
    total,
  }
}

export function validateShippingForm(data, t) {
  const errors = {}

  if (!data.firstName?.trim()) {
    errors.firstName = t('forms.errors.firstNameRequired')
  }

  if (!data.lastName?.trim()) {
    errors.lastName = t('forms.errors.lastNameRequired')
  }

  if (!data.email?.trim()) {
    errors.email = t('forms.errors.emailRequired')
  } else if (!EMAIL_PATTERN.test(data.email.trim())) {
    errors.email = t('forms.errors.emailInvalid')
  }

  if (!data.phone?.trim()) {
    errors.phone = t('forms.errors.phoneRequired')
  } else if (!PHONE_PATTERN.test(data.phone.trim())) {
    errors.phone = t('forms.errors.phoneInvalid')
  }

  if (!data.address?.trim()) {
    errors.address = t('forms.errors.addressRequired')
  }

  if (!data.city?.trim()) {
    errors.city = t('forms.errors.cityRequired')
  }

  if (!data.state?.trim()) {
    errors.state = t('forms.errors.stateRequired')
  }

  if (!data.zip?.trim()) {
    errors.zip = t('forms.errors.zipRequired')
  } else if (!POSTAL_PATTERN.test(data.zip.trim())) {
    errors.zip = t('forms.errors.zipInvalid')
  }

  return errors
}

export function validateDemoPaymentForm(data, t) {
  const errors = {}

  const cardNumber = data.cardNumber?.replace(/\s/g, '') || ''
  if (!cardNumber) {
    errors.cardNumber = t('forms.errors.cardNumberRequired')
  } else if (!/^\d{13,19}$/.test(cardNumber)) {
    errors.cardNumber = t('forms.errors.cardNumberInvalid')
  }

  if (!data.cardName?.trim()) {
    errors.cardName = t('forms.errors.cardNameRequired')
  }

  if (!data.expiry?.trim()) {
    errors.expiry = t('forms.errors.expiryRequired')
  } else if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(data.expiry.trim())) {
    errors.expiry = t('forms.errors.expiryInvalid')
  }

  if (!data.cvv?.trim()) {
    errors.cvv = t('forms.errors.cvvRequired')
  } else if (!/^\d{3,4}$/.test(data.cvv.trim())) {
    errors.cvv = t('forms.errors.cvvInvalid')
  }

  return errors
}

export function buildCustomerFromForm(formData) {
  return {
    firstName: formData.firstName.trim(),
    lastName: formData.lastName.trim(),
    email: formData.email.trim(),
    phone: formData.phone.trim(),
    address: formData.address.trim(),
    city: formData.city.trim(),
    state: formData.state.trim(),
    zip: formData.zip.trim(),
  }
}

import { getProductField } from '../i18n/products'

export function buildOrderItems(cartItems, lang = 'en') {
  return cartItems.map((item) => ({
    productId: item.product.id,
    name: getProductField(item.product, 'name', lang),
    price: item.product.price,
    quantity: item.quantity,
    lineTotal: item.lineTotal,
    image: item.product.image,
  }))
}

function generateOrderId() {
  const stamp = Date.now().toString(36).toUpperCase()
  const random = Math.random().toString(36).slice(2, 6).toUpperCase()
  return `OE-${stamp}-${random}`
}

export function createOrderRecord({
  formData,
  cartItems,
  totals,
  payment,
  lang = 'en',
}) {
  return {
    id: generateOrderId(),
    createdAt: new Date().toISOString(),
    status: 'confirmed',
    customer: buildCustomerFromForm(formData),
    items: buildOrderItems(cartItems, lang),
    totals,
    payment,
    lang,
  }
}
