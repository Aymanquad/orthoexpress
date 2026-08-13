import React from 'react'
import { Link } from 'react-router-dom'
import { FaMinus, FaPlus, FaTrash } from 'react-icons/fa'
import { useCart } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { formatPrice } from '../data/products'
import { getProductField } from '../i18n/products'
import { calculateOrderTotals } from '../utils/checkout'
import PageMeta from '../components/PageMeta'
import './Cart.css'

const Cart = () => {
  const { t, lang } = useLanguage()
  const { cartItems, cartCount, subtotal, updateQuantity, removeFromCart } = useCart()
  const totals = calculateOrderTotals(subtotal)
  const itemLabel = cartCount === 1 ? t('shop.item') : t('shop.items')

  if (cartCount === 0) {
    return (
      <div className="cart-page">
        <PageMeta title={t('pages.meta.cart.title')} description={t('pages.meta.cart.description')} />
        <section className="cart-hero section">
          <div className="container">
            <h1 className="page-title">{t('shop.cartTitle')}</h1>
          </div>
        </section>
        <section className="cart-content section">
          <div className="container">
            <div className="cart-empty">
              <p>{t('shop.cartEmpty')}</p>
              <Link to="/shop" className="btn btn-primary">
                {t('shop.continueShopping')}
              </Link>
            </div>
          </div>
        </section>
      </div>
    )
  }

  return (
    <div className="cart-page">
      <PageMeta title={t('pages.meta.cart.title')} description={t('pages.meta.cart.description')} />

      <section className="cart-hero section">
        <div className="container">
          <h1 className="page-title">{t('shop.cartTitle')}</h1>
          <p className="cart-subtitle">
            {t('shop.cartSubtitle')
              .replace('{count}', cartCount)
              .replace('{items}', itemLabel)}
          </p>
        </div>
      </section>

      <section className="cart-content section">
        <div className="container cart-layout">
          <div className="cart-items">
            {cartItems.map((item) => {
              const productName = getProductField(item.product, 'name', lang)
              return (
                <article key={item.productId} className="cart-item">
                  <div className="cart-item-image-wrap">
                    <img src={item.product.image} alt={productName} className="cart-item-image" />
                  </div>
                  <div className="cart-item-details">
                    <h2 className="cart-item-title">{productName}</h2>
                    <p className="cart-item-price">{formatPrice(item.product.price, lang)}</p>
                    <div className="cart-item-actions">
                      <div
                        className="cart-qty-control"
                        aria-label={`${t('shop.quantityFor')} ${productName}`}
                      >
                        <button
                          type="button"
                          className="cart-qty-btn"
                          onClick={() => updateQuantity(item.productId, item.quantity - 1)}
                          aria-label={t('shop.decreaseQty')}
                        >
                          <FaMinus />
                        </button>
                        <span className="cart-qty-value">{item.quantity}</span>
                        <button
                          type="button"
                          className="cart-qty-btn"
                          onClick={() => updateQuantity(item.productId, item.quantity + 1)}
                          aria-label={t('shop.increaseQty')}
                        >
                          <FaPlus />
                        </button>
                      </div>
                      <button
                        type="button"
                        className="cart-remove-btn"
                        onClick={() => removeFromCart(item.productId)}
                      >
                        <FaTrash aria-hidden="true" /> {t('shop.remove')}
                      </button>
                    </div>
                  </div>
                  <div className="cart-item-line-total">
                    {formatPrice(item.lineTotal, lang)}
                  </div>
                </article>
              )
            })}
          </div>

          <aside className="cart-summary">
            <h2>{t('shop.orderSummary')}</h2>
            <div className="cart-summary-row">
              <span>{t('shop.subtotal')}</span>
              <span>{formatPrice(totals.subtotal, lang)}</span>
            </div>
            <div className="cart-summary-row">
              <span>{t('shop.shipping')}</span>
              <span>{formatPrice(totals.shipping, lang)}</span>
            </div>
            <div className="cart-summary-row">
              <span>{t('shop.estimatedTax')}</span>
              <span>{formatPrice(totals.tax, lang)}</span>
            </div>
            <div className="cart-summary-row cart-summary-total">
              <span>{t('shop.total')}</span>
              <span>{formatPrice(totals.total, lang)}</span>
            </div>
            <Link to="/checkout" className="btn btn-primary btn-large cart-checkout-btn">
              {t('shop.proceedCheckout')}
            </Link>
            <Link to="/shop" className="cart-continue-link">
              {t('shop.continueShopping')}
            </Link>
          </aside>
        </div>
      </section>
    </div>
  )
}

export default Cart
