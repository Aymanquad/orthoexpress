import React, { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useCart, saveOrderToStorage } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { formatPrice } from '../data/products'
import { getProductField } from '../i18n/products'
import { isDemoPaymentMode } from '../config/payment'
import { calculateOrderTotals } from '../utils/checkout'
import { processCheckoutPayment } from '../utils/payment'
import PaymentFields from '../components/shop/PaymentFields'
import PageMeta from '../components/PageMeta'
import '../components/FormFeedback.css'
import '../components/shop/DemoPaymentFields.css'
import './Checkout.css'

const initialFormState = {
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  state: '',
  zip: '',
  cardNumber: '',
  cardName: '',
  expiry: '',
  cvv: '',
}

const Checkout = () => {
  const navigate = useNavigate()
  const { t, lang } = useLanguage()
  const { cartItems, cartCount, subtotal, clearCart } = useCart()
  const [formData, setFormData] = useState(initialFormState)
  const [errors, setErrors] = useState({})
  const [isProcessing, setIsProcessing] = useState(false)
  const totals = calculateOrderTotals(subtotal)

  const handleChange = (e) => {
    const { name, value } = e.target
    let nextValue = value

    if (name === 'cardNumber') {
      nextValue = value.replace(/\D/g, '').slice(0, 16).replace(/(\d{4})(?=\d)/g, '$1 ')
    }

    if (name === 'expiry') {
      const digits = value.replace(/\D/g, '').slice(0, 4)
      nextValue = digits.length > 2 ? `${digits.slice(0, 2)}/${digits.slice(2)}` : digits
    }

    if (name === 'cvv') {
      nextValue = value.replace(/\D/g, '').slice(0, 4)
    }

    setFormData((prev) => ({ ...prev, [name]: nextValue }))
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }))
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setIsProcessing(true)
    setErrors({})

    try {
      const result = await processCheckoutPayment(formData, cartItems, totals, null, t, lang)

      if (!result.success) {
        if (result.errors) {
          setErrors(result.errors)
        } else {
          navigate('/order-failure', {
            state: { message: result.error },
          })
        }
        return
      }

      saveOrderToStorage(result.order)
      clearCart()
      navigate(`/order-success/${result.order.id}`, { replace: true })
    } catch (error) {
      navigate('/order-failure', {
        state: {
          message: error.message || t('shop.paymentProcessingError'),
        },
      })
    } finally {
      setIsProcessing(false)
    }
  }

  if (cartCount === 0) {
    return (
      <div className="checkout-page">
        <PageMeta
          title={t('pages.meta.checkout.title')}
          description={t('pages.meta.checkout.description')}
        />
        <section className="checkout-hero section">
          <div className="container">
            <h1 className="page-title">{t('shop.checkoutTitle')}</h1>
          </div>
        </section>
        <section className="checkout-content section">
          <div className="container">
            <div className="checkout-empty">
              <p>{t('shop.cartEmptyCheckout')}</p>
              <Link to="/shop" className="btn btn-primary">
                {t('shop.goToShop')}
              </Link>
            </div>
          </div>
        </section>
      </div>
    )
  }

  return (
    <div className="checkout-page">
      <PageMeta
        title={t('pages.meta.checkout.title')}
        description={t('pages.meta.checkout.description')}
      />

      <section className="checkout-hero section">
        <div className="container">
          <h1 className="page-title">{t('shop.checkoutTitle')}</h1>
          {isDemoPaymentMode() && (
            <p className="checkout-hero-note">{t('shop.demoCheckoutNote')}</p>
          )}
        </div>
      </section>

      <section className="checkout-content section">
        <div className="container checkout-layout">
          <form className="checkout-form" onSubmit={handleSubmit} noValidate>
            <div className="checkout-section">
              <h2>{t('shop.shippingInfo')}</h2>
              <div className="checkout-grid">
                <div className="form-group">
                  <label htmlFor="firstName">{t('shop.firstName')}</label>
                  <input
                    id="firstName"
                    name="firstName"
                    value={formData.firstName}
                    onChange={handleChange}
                    className={errors.firstName ? 'input-error' : ''}
                  />
                  {errors.firstName && <span className="field-error">{errors.firstName}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="lastName">{t('shop.lastName')}</label>
                  <input
                    id="lastName"
                    name="lastName"
                    value={formData.lastName}
                    onChange={handleChange}
                    className={errors.lastName ? 'input-error' : ''}
                  />
                  {errors.lastName && <span className="field-error">{errors.lastName}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="email">{t('shop.email')}</label>
                  <input
                    id="email"
                    name="email"
                    type="email"
                    value={formData.email}
                    onChange={handleChange}
                    className={errors.email ? 'input-error' : ''}
                  />
                  {errors.email && <span className="field-error">{errors.email}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="phone">{t('shop.phone')}</label>
                  <input
                    id="phone"
                    name="phone"
                    type="tel"
                    value={formData.phone}
                    onChange={handleChange}
                    className={errors.phone ? 'input-error' : ''}
                  />
                  {errors.phone && <span className="field-error">{errors.phone}</span>}
                </div>
                <div className="form-group checkout-full-width">
                  <label htmlFor="address">{t('shop.address')}</label>
                  <input
                    id="address"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                    className={errors.address ? 'input-error' : ''}
                  />
                  {errors.address && <span className="field-error">{errors.address}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="city">{t('shop.city')}</label>
                  <input
                    id="city"
                    name="city"
                    value={formData.city}
                    onChange={handleChange}
                    className={errors.city ? 'input-error' : ''}
                  />
                  {errors.city && <span className="field-error">{errors.city}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="state">{t('shop.state')}</label>
                  <input
                    id="state"
                    name="state"
                    value={formData.state}
                    onChange={handleChange}
                    className={errors.state ? 'input-error' : ''}
                  />
                  {errors.state && <span className="field-error">{errors.state}</span>}
                </div>
                <div className="form-group">
                  <label htmlFor="zip">{t('shop.zip')}</label>
                  <input
                    id="zip"
                    name="zip"
                    value={formData.zip}
                    onChange={handleChange}
                    className={errors.zip ? 'input-error' : ''}
                  />
                  {errors.zip && <span className="field-error">{errors.zip}</span>}
                </div>
              </div>
            </div>

            <div className="checkout-section">
              <h2>{t('shop.paymentInfo')}</h2>
              <PaymentFields formData={formData} errors={errors} onChange={handleChange} />
            </div>

            <button type="submit" className="btn btn-primary btn-large checkout-submit-btn" disabled={isProcessing}>
              {isProcessing
                ? t('shop.processing')
                : isDemoPaymentMode()
                  ? `${t('shop.completeDemoOrder')} — ${formatPrice(totals.total, lang)}`
                  : `${t('shop.pay')} ${formatPrice(totals.total, lang)}`}
            </button>
          </form>

          <aside className="checkout-summary">
            <h2>{t('shop.orderSummary')}</h2>
            <ul className="checkout-items">
              {cartItems.map((item) => {
                const productName = getProductField(item.product, 'name', lang)
                return (
                  <li key={item.productId} className="checkout-item">
                    <img src={item.product.image} alt="" className="checkout-item-image" />
                    <div>
                      <p className="checkout-item-name">{productName}</p>
                      <p className="checkout-item-meta">
                        {t('shop.qty')} {item.quantity}
                      </p>
                    </div>
                    <span>{formatPrice(item.lineTotal, lang)}</span>
                  </li>
                )
              })}
            </ul>
            <div className="checkout-summary-row">
              <span>{t('shop.subtotal')}</span>
              <span>{formatPrice(totals.subtotal, lang)}</span>
            </div>
            <div className="checkout-summary-row">
              <span>{t('shop.shipping')}</span>
              <span>{formatPrice(totals.shipping, lang)}</span>
            </div>
            <div className="checkout-summary-row">
              <span>{t('shop.tax')}</span>
              <span>{formatPrice(totals.tax, lang)}</span>
            </div>
            <div className="checkout-summary-row checkout-summary-total">
              <span>{t('shop.total')}</span>
              <span>{formatPrice(totals.total, lang)}</span>
            </div>
          </aside>
        </div>
      </section>
    </div>
  )
}

export default Checkout
