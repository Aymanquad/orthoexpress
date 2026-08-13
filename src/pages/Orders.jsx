import React from 'react'
import { Link } from 'react-router-dom'
import { FaBoxOpen, FaShoppingBag } from 'react-icons/fa'
import { useLanguage } from '../context/LanguageContext'
import { useOrders } from '../hooks/useOrders'
import { formatPrice } from '../data/products'
import {
  formatOrderDate,
  getOrderItemCount,
  getOrderStatusInfo,
} from '../utils/orders'
import PageMeta from '../components/PageMeta'
import './Orders.css'

const Orders = () => {
  const { t, lang } = useLanguage()
  const { orders } = useOrders()

  return (
    <div className="orders-page">
      <PageMeta title={t('pages.meta.orders.title')} description={t('pages.meta.orders.description')} />

      <section className="orders-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.orders.title')}</h1>
          <p className="orders-subtitle">{t('shop.ordersSavedLocally')}</p>
        </div>
      </section>

      <section className="orders-content section">
        <div className="container">
          {orders.length === 0 ? (
            <div className="orders-empty">
              <FaShoppingBag className="orders-empty-icon" aria-hidden="true" />
              <h2>{t('shop.noOrdersYet')}</h2>
              <p>{t('shop.ordersEmptyText')}</p>
              <Link to="/shop" className="btn btn-primary">
                {t('shop.browseShop')}
              </Link>
            </div>
          ) : (
            <div className="orders-list">
              {orders.map((order) => {
                const status = getOrderStatusInfo(order, t)
                const itemCount = getOrderItemCount(order)
                const itemLabel = itemCount === 1 ? t('shop.item') : t('shop.items')

                return (
                  <article key={order.id} className="orders-card">
                    <div className="orders-card-header">
                      <div>
                        <p className="orders-card-id">
                          {t('pages.orders.orderNumber')} {order.id}
                        </p>
                        <p className="orders-card-date">{formatOrderDate(order.createdAt, lang)}</p>
                      </div>
                      <span className={`orders-status orders-status--${status.tone}`}>
                        {status.label}
                      </span>
                    </div>

                    <p className="orders-card-meta">
                      {itemCount} {itemLabel} · {order.customer.firstName} {order.customer.lastName}
                    </p>

                    <ul className="orders-card-items">
                      {order.items.map((item) => (
                        <li key={`${order.id}-${item.productId}`} className="orders-card-item">
                          <img src={item.image} alt="" className="orders-card-item-image" />
                          <div className="orders-card-item-details">
                            <p className="orders-card-item-name">{item.name}</p>
                            <p className="orders-card-item-qty">
                              {t('shop.qty')} {item.quantity}
                            </p>
                          </div>
                          <span className="orders-card-item-price">{formatPrice(item.lineTotal, lang)}</span>
                        </li>
                      ))}
                    </ul>

                    <div className="orders-card-footer">
                      <div>
                        <p className="orders-card-total-label">{t('shop.totalPaid')}</p>
                        <p className="orders-card-total">{formatPrice(order.totals.total, lang)}</p>
                        <p className="orders-card-status-note">{status.description}</p>
                      </div>
                      <Link to={`/order-success/${order.id}`} className="btn btn-outline orders-view-btn">
                        <FaBoxOpen aria-hidden="true" /> {t('shop.viewReceipt')}
                      </Link>
                    </div>
                  </article>
                )
              })}
            </div>
          )}
        </div>
      </section>
    </div>
  )
}

export default Orders
