/**
 * Payment configuration.
 *
 * Modes:
 * - demo  → simulated checkout (current default, no real charges)
 * - stripe → live Stripe Payments (requires backend + publishable key)
 */
export const PAYMENT_MODE = import.meta.env.VITE_PAYMENT_MODE || 'demo'

export const STRIPE_PUBLISHABLE_KEY = import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY || ''

/** Backend endpoint that creates a Stripe PaymentIntent (server-side only). */
export const STRIPE_PAYMENT_INTENT_URL =
  import.meta.env.VITE_STRIPE_PAYMENT_INTENT_URL || '/api/create-payment-intent'

export const isDemoPaymentMode = () => PAYMENT_MODE === 'demo'

export const isStripePaymentMode = () =>
  PAYMENT_MODE === 'stripe' && Boolean(STRIPE_PUBLISHABLE_KEY)

export const getPaymentModeLabel = () => {
  if (isStripePaymentMode()) return 'Stripe'
  return 'Demo'
}
