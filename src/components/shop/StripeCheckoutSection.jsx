/**
 * Stripe Checkout integration point.
 *
 * When going live:
 * 1. npm install @stripe/stripe-js @stripe/react-stripe-js
 * 2. Set VITE_PAYMENT_MODE=stripe and VITE_STRIPE_PUBLISHABLE_KEY
 * 3. Implement backend POST /api/create-payment-intent
 * 4. Replace this placeholder with Elements + PaymentElement
 */
import { isStripePaymentMode } from '../../config/payment'

const StripeCheckoutSection = ({ totals, onPaymentMethodReady }) => {
  if (!isStripePaymentMode()) {
    return null
  }

  return (
    <div className="stripe-checkout-section">
      <p className="checkout-payment-note">
        Stripe Elements mount here. Total to charge: ${totals.total.toFixed(2)}
      </p>
      <button
        type="button"
        className="btn btn-outline"
        onClick={() => onPaymentMethodReady?.('pm_demo_placeholder')}
      >
        Placeholder: confirm Stripe setup
      </button>
    </div>
  )
}

export default StripeCheckoutSection
