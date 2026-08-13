import { useLanguage } from '../../context/LanguageContext'
import { isDemoPaymentMode, isStripePaymentMode } from '../../config/payment'
import './DemoPaymentFields.css'

const DemoPaymentFields = ({ formData, errors, onChange, t }) => (
  <div className="demo-payment-fields">
    <div className="checkout-payment-badge">{t('shop.demoPayment')}</div>
    <p className="checkout-payment-note">{t('shop.paymentDemoNote')}</p>
    <div className="checkout-grid">
      <div className="form-group checkout-full-width">
        <label htmlFor="cardName">{t('shop.cardName')}</label>
        <input
          id="cardName"
          name="cardName"
          value={formData.cardName}
          onChange={onChange}
          className={errors.cardName ? 'input-error' : ''}
        />
        {errors.cardName && <span className="field-error">{errors.cardName}</span>}
      </div>
      <div className="form-group checkout-full-width">
        <label htmlFor="cardNumber">{t('shop.cardNumber')}</label>
        <input
          id="cardNumber"
          name="cardNumber"
          inputMode="numeric"
          autoComplete="cc-number"
          value={formData.cardNumber}
          onChange={onChange}
          placeholder="4242 4242 4242 4242"
          className={errors.cardNumber ? 'input-error' : ''}
        />
        {errors.cardNumber && <span className="field-error">{errors.cardNumber}</span>}
      </div>
      <div className="form-group">
        <label htmlFor="expiry">{t('shop.expiry')}</label>
        <input
          id="expiry"
          name="expiry"
          inputMode="numeric"
          autoComplete="cc-exp"
          value={formData.expiry}
          onChange={onChange}
          placeholder="MM/YY"
          className={errors.expiry ? 'input-error' : ''}
        />
        {errors.expiry && <span className="field-error">{errors.expiry}</span>}
      </div>
      <div className="form-group">
        <label htmlFor="cvv">{t('shop.cvv')}</label>
        <input
          id="cvv"
          name="cvv"
          inputMode="numeric"
          autoComplete="cc-csc"
          value={formData.cvv}
          onChange={onChange}
          className={errors.cvv ? 'input-error' : ''}
        />
        {errors.cvv && <span className="field-error">{errors.cvv}</span>}
      </div>
    </div>
  </div>
)

export const PaymentFields = ({ formData, errors, onChange }) => {
  const { t } = useLanguage()

  if (isStripePaymentMode()) {
    return (
      <div className="stripe-payment-placeholder">
        <div className="checkout-payment-badge stripe">{t('shop.paymentStripe')}</div>
        <p className="checkout-payment-note">{t('shop.stripePlaceholder')}</p>
      </div>
    )
  }

  if (isDemoPaymentMode()) {
    return <DemoPaymentFields formData={formData} errors={errors} onChange={onChange} t={t} />
  }

  return <p className="checkout-payment-note">{t('shop.paymentNotConfigured')}</p>
}

export default PaymentFields
