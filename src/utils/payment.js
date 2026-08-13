import {
  isDemoPaymentMode,
  isStripePaymentMode,
  STRIPE_PAYMENT_INTENT_URL,
} from '../config/payment'
import { getProductField } from '../i18n/products'
import {
  buildCustomerFromForm,
  createOrderRecord,
  validateDemoPaymentForm,
  validateShippingForm,
} from './checkout'

/**
 * Payment service — routes checkout to demo or Stripe based on VITE_PAYMENT_MODE.
 *
 * Stripe flow (when enabled):
 * 1. Frontend calls backend to create PaymentIntent (amount in cents, order metadata).
 * 2. Frontend confirms payment with Stripe.js + client secret.
 * 3. On success, order is saved and cart is cleared.
 *
 * Requires a server endpoint at VITE_STRIPE_PAYMENT_INTENT_URL.
 * Install when going live: @stripe/stripe-js @stripe/react-stripe-js
 */

function getCardBrand(cardNumber) {
  if (cardNumber.startsWith('4')) return 'Visa'
  if (cardNumber.startsWith('5')) return 'Mastercard'
  if (cardNumber.startsWith('3')) return 'Amex'
  return 'Card'
}

/**
 * Demo payment — simulates processing. Cards ending in 0000 are declined.
 */
export async function processDemoPayment(formData, cartItems, totals, t, lang = 'en') {
  const shippingErrors = validateShippingForm(formData, t)
  const paymentErrors = validateDemoPaymentForm(formData, t)
  const errors = { ...shippingErrors, ...paymentErrors }

  if (Object.keys(errors).length > 0) {
    return { success: false, errors }
  }

  if (!cartItems.length) {
    return { success: false, error: t('shop.cartEmpty') }
  }

  await new Promise((resolve) => setTimeout(resolve, 1200))

  const cardNumber = formData.cardNumber.replace(/\s/g, '')
  if (cardNumber.endsWith('0000')) {
    return {
      success: false,
      error: t('shop.paymentDeclined'),
    }
  }

  const order = createOrderRecord({
    formData,
    cartItems,
    totals,
    payment: {
      provider: 'demo',
      status: 'succeeded',
      last4: cardNumber.slice(-4),
      brand: getCardBrand(cardNumber),
    },
    lang,
  })

  return { success: true, order }
}

/**
 * Creates a Stripe PaymentIntent via your backend.
 * Backend must use the Stripe secret key — never expose it in the frontend.
 */
export async function createStripePaymentIntent({ cartItems, totals, customer, t, lang = 'en' }) {
  const response = await fetch(STRIPE_PAYMENT_INTENT_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      amount: Math.round(totals.total * 100),
      currency: 'usd',
      customer,
      items: cartItems.map((item) => ({
        id: item.product.id,
        name: getProductField(item.product, 'name', lang),
        quantity: item.quantity,
        unitAmount: Math.round(item.product.price * 100),
      })),
      metadata: {
        source: 'orthoexpress-shop',
      },
    }),
  })

  if (!response.ok) {
    const payload = await response.json().catch(() => ({}))
    throw new Error(payload.error || t('shop.stripeStartFailed'))
  }

  return response.json()
}

/**
 * Stripe payment — placeholder for live integration.
 * Wire up Stripe Elements + confirmCardPayment when backend is ready.
 */
export async function processStripePayment(formData, cartItems, totals, stripePaymentMethodId, t, lang = 'en') {
  const shippingErrors = validateShippingForm(formData, t)
  if (Object.keys(shippingErrors).length > 0) {
    return { success: false, errors: shippingErrors }
  }

  if (!cartItems.length) {
    return { success: false, error: t('shop.cartEmpty') }
  }

  if (!stripePaymentMethodId) {
    return { success: false, error: t('shop.paymentMethodRequired') }
  }

  const customer = buildCustomerFromForm(formData)
  const intentPayload = await createStripePaymentIntent({ cartItems, totals, customer, t, lang })

  // When Stripe.js is integrated, confirm the PaymentIntent here:
  // const stripe = await loadStripe(STRIPE_PUBLISHABLE_KEY)
  // const { error, paymentIntent } = await stripe.confirmCardPayment(intentPayload.clientSecret, { ... })

  if (!intentPayload?.clientSecret) {
    return {
      success: false,
      error: t('shop.stripeNotConfigured'),
    }
  }

  const order = createOrderRecord({
    formData,
    cartItems,
    totals,
    payment: {
      provider: 'stripe',
      status: 'succeeded',
      paymentIntentId: intentPayload.paymentIntentId || intentPayload.id,
      clientSecret: intentPayload.clientSecret,
      paymentMethodId: stripePaymentMethodId,
    },
    lang,
  })

  return { success: true, order }
}

/**
 * Main checkout entry point — used by the Checkout page.
 */
export async function processCheckoutPayment(
  formData,
  cartItems,
  totals,
  stripePaymentMethodId = null,
  t = (key, fallback = '') => fallback || key,
  lang = 'en'
) {
  if (isStripePaymentMode()) {
    return processStripePayment(formData, cartItems, totals, stripePaymentMethodId, t, lang)
  }

  if (isDemoPaymentMode()) {
    return processDemoPayment(formData, cartItems, totals, t, lang)
  }

  return {
    success: false,
    error: t('shop.paymentNotConfigured'),
  }
}
