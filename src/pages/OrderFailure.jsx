import React from 'react'
import { Link, useLocation } from 'react-router-dom'
import { FaTimesCircle } from 'react-icons/fa'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import './OrderStatus.css'

const OrderFailure = () => {
  const { t } = useLanguage()
  const location = useLocation()
  const message = location.state?.message || t('shop.paymentFailedDefault')

  return (
    <div className="order-status-page">
      <PageMeta title={t('shop.paymentFailedTitle')} description={t('shop.paymentFailedDefault')} />

      <section className="order-status-content section">
        <div className="container order-status-card order-status-failure">
          <FaTimesCircle className="order-status-icon failure" aria-hidden="true" />
          <h1 className="page-title">{t('shop.paymentFailedTitle')}</h1>
          <p className="order-status-message">{message}</p>
          <p className="order-status-help">{t('shop.orderHelp')}</p>

          <div className="order-status-actions">
            <Link to="/checkout" className="btn btn-primary">
              {t('shop.tryAgain')}
            </Link>
            <Link to="/cart" className="btn btn-outline">
              {t('shop.backToCart')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default OrderFailure
