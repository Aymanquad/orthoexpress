import React from 'react'
import { Link, useParams } from 'react-router-dom'
import { FaCheckCircle } from 'react-icons/fa'
import { getOrderById } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { formatPrice } from '../data/products'
import PageMeta from '../components/PageMeta'
import './OrderStatus.css'

const OrderSuccess = () => {
  const { t, lang } = useLanguage()
  const { orderId } = useParams()
  const order = getOrderById(orderId)

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

  const thankYouMessage = t('shop.orderThankYou').replace('{name}', order.customer.firstName)
  const confirmationEmail = t('shop.confirmationEmail').replace('{email}', order.customer.email)

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
