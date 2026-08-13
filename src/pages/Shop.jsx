import React, { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { FaShoppingCart, FaShieldAlt, FaTruck, FaLeaf } from 'react-icons/fa'
import { PRODUCTS, PRODUCT_CATEGORIES } from '../data/products'
import { useCart } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { getCategoryLabel } from '../i18n/products'
import ProductCard from '../components/shop/ProductCard'
import PageMeta from '../components/PageMeta'
import './Shop.css'

const SHOP_PERK_ICONS = [FaLeaf, FaTruck, FaShieldAlt]

const Shop = () => {
  const { t } = useLanguage()
  const [activeCategory, setActiveCategory] = useState('all')
  const { cartCount } = useCart()

  const filteredProducts = useMemo(() => {
    if (activeCategory === 'all') return PRODUCTS
    return PRODUCTS.filter((product) => product.category === activeCategory)
  }, [activeCategory])

  return (
    <div className="shop-page">
      <PageMeta
        title={t('pages.meta.shop.title')}
        description={t('pages.meta.shop.description')}
      />

      <section className="shop-hero">
        <div className="container shop-hero-inner">
          <span className="shop-eyebrow">{t('shop.eyebrow')}</span>
          <h1 className="page-title">{t('shop.title')}</h1>
          <p className="shop-subtitle">{t('shop.subtitle')}</p>
          <div className="shop-perks">
            {SHOP_PERK_ICONS.map((Icon, index) => (
              <span key={index} className="shop-perk">
                <Icon aria-hidden="true" />
                {t(`shop.perks.${index}`)}
              </span>
            ))}
          </div>
        </div>
      </section>

      <section className="shop-content">
        <div className="container">
          <div className="shop-toolbar">
            <div className="shop-toolbar-left">
              <p className="shop-count">
                {filteredProducts.length} {t('shop.products')}
              </p>
              <div className="shop-category-pills" role="tablist" aria-label={t('shop.productCategories')}>
                {PRODUCT_CATEGORIES.map((category) => (
                  <button
                    key={category.id}
                    type="button"
                    role="tab"
                    aria-selected={activeCategory === category.id}
                    className={`shop-category-pill ${activeCategory === category.id ? 'active' : ''}`}
                    onClick={() => setActiveCategory(category.id)}
                  >
                    {getCategoryLabel(category.id, t)}
                  </button>
                ))}
              </div>
            </div>
            <div className="shop-toolbar-actions">
              <Link to="/orders" className="shop-toolbar-link">
                {t('shop.myOrders')}
              </Link>
              <Link to="/cart" className="shop-cart-chip">
                <FaShoppingCart aria-hidden="true" />
                {t('shop.cart')}
                {cartCount > 0 ? ` (${cartCount})` : ''}
              </Link>
            </div>
          </div>

          <div className="shop-grid">
            {filteredProducts.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>

          {filteredProducts.length === 0 && (
            <div className="shop-empty-filter">
              <p>{t('shop.emptyCategory')}</p>
              <button
                type="button"
                className="btn btn-outline"
                onClick={() => setActiveCategory('all')}
              >
                {t('shop.showAll')}
              </button>
            </div>
          )}
        </div>
      </section>
    </div>
  )
}

export default Shop
