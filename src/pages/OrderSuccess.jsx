import React, { useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { FaCheckCircle } from 'react-icons/fa'
import { getOrderById, updateOrderInStorage } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { useAuth } from '../context/AuthContext'
import { formatPrice } from '../data/products'
import { syncOrderToServer } from '../utils/orderSync'
import PageMeta from '../components/PageMeta'
import './OrderStatus.css'

function formatPhoneInput(value) {
  const digits = value.replace(/\D/g, '').slice(0, 10)
  if (digits.length <= 3) return digits
  if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`
  return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6)}`
}

const OrderSuccess = () => {
  const { t, lang } = useLanguage()
  const { isAuthenticated } = useAuth()
  const { orderId } = useParams()
  const [order, setOrder] = useState(() => getOrderById(orderId))
  const [phoneInput, setPhoneInput] = useState(() => {
    const raw = order?.customer?.phone?.replace(/\D/g, '') || ''
    const national = raw.length === 11 && raw.startsWith('1') ? raw.slice(1) : raw.slice(-10)
    return national ? formatPhoneInput(national) : ''
  })
  const [saved, setSaved] = useState(false)
  const [linking, setLinking] = useState(false)
  const [error, setError] = useState('')

  const thankYouMessage = useMemo(() => {
    if (!order) return ''
    return t('shop.orderThankYou').replace('{name}', order.customer.firstName)
  }, [order, t])

  if (!order) {
    return (
      <div className="order-status-page">
        <PageMeta title={t('shop.orderNotFound')} description={t('pages.meta.orders.description')} />
        <section className="order-status-content section">
          <div className="container order-status-card">
            <h1 className="page-title">{t('shop.orderNotFound')}</h1>
            <p>{t('shop.orderNotFoundText')}</p>
            <Link to="/shop" className="btn btn-primary">
              {t('shop.goToShop')}
            </Link>
          </div>
        </section>
      </div>
    )
  }

  const confirmationEmail = t('shop.confirmationEmail').replace('{email}', order.customer.email)

  const handleSavePhone = async (e) => {
    e.preventDefault()
    const digits = phoneInput.replace(/\D/g, '')
    if (digits.length !== 10) {
      setError(t('shop.orderPhoneInvalid'))
      return
    }

    setError('')
    setLinking(true)
    try {
      const updated = updateOrderInStorage(order.id, {
        customer: { ...order.customer, phone: phoneInput },
      })
      if (!updated) {
        setError(t('shop.orderPhoneSaveFailed'))
        return
      }
      setOrder(updated)
      const sync = await syncOrderToServer(updated)
      setSaved(true)
      if (!sync.synced) {
        setError(t('shop.orderPhoneLocalOnly'))
      }
    } catch (err) {
      setError(err.message || t('portal.errors.generic'))
    } finally {
      setLinking(false)
    }
  }

  return (
    <div className="order-status-page">
      <PageMeta title={t('shop.orderConfirmedTitle')} description={t('pages.meta.orders.description')} />

      <section className="order-status-content section">
        <div className="container order-status-card order-status-success">
          <FaCheckCircle className="order-status-icon success" aria-hidden="true" />
          <h1 className="page-title">{t('shop.orderConfirmedTitle')}</h1>
          <p className="order-status-message">{thankYouMessage}</p>
          <p className="order-status-id">
            {t('shop.orderId')}: <strong>{order.id}</strong>
          </p>

          <div className="order-status-summary">
            <h2>{t('shop.orderDetails')}</h2>
            <ul className="order-status-items">
              {order.items.map((item) => (
                <li key={`${item.productId}-${item.quantity}`}>
                  <span>
                    {item.name} × {item.quantity}
                  </span>
                  <span>{formatPrice(item.lineTotal, lang)}</span>
                </li>
              ))}
            </ul>
            <div className="order-status-total">
              <span>{t('shop.totalPaid')}</span>
              <span>{formatPrice(order.totals.total, lang)}</span>
            </div>
            <p className="order-status-shipping">
              {t('shop.shippingTo')}: {order.customer.address}, {order.customer.city},{' '}
              {order.customer.state} {order.customer.zip}
            </p>
            <p className="order-status-email">{confirmationEmail}</p>
            {order.payment?.provider && (
              <p className="order-status-payment">
                {t('shop.paymentInfo')}:{' '}
                {order.payment.provider === 'demo' ? t('shop.paymentDemo') : t('shop.paymentStripe')}
                {order.payment.last4 ? ` •••• ${order.payment.last4}` : ''}
              </p>
            )}
          </div>

          <div className="order-phone-link">
            <h2>{t('shop.orderPhoneTitle')}</h2>
            <p>{t('shop.orderPhoneHelp')}</p>

            <form className="order-phone-form" onSubmit={handleSavePhone}>
              <label htmlFor="order-link-phone">{t('shop.phone')} *</label>
              <input
                id="order-link-phone"
                type="tel"
                inputMode="tel"
                autoComplete="tel"
                placeholder="(213) 555-0100"
                value={phoneInput}
                onChange={(e) => {
                  setPhoneInput(formatPhoneInput(e.target.value))
                  setSaved(false)
                }}
                required
              />
              {error && <p className="field-error">{error}</p>}
              {saved && <p className="order-phone-synced">{t('shop.orderPhoneSynced')}</p>}
              <button type="submit" className="btn btn-primary" disabled={linking}>
                {linking ? t('shop.orderPhoneSaving') : t('shop.orderPhoneSave')}
              </button>
            </form>

            {!isAuthenticated && (
              <p className="order-phone-portal">
                <Link to="/portal/login">{t('shop.orderPhonePortalCta')}</Link>
              </p>
            )}
            {isAuthenticated && (
              <p className="order-phone-portal">
                <Link to="/portal">{t('portal.goToDashboard')}</Link>
              </p>
            )}
          </div>

          <div className="order-status-actions">
            <Link to="/orders" className="btn btn-primary">
              {t('shop.viewAllOrders')}
            </Link>
            <Link to="/shop" className="btn btn-outline">
              {t('shop.continueShopping')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default OrderSuccess
