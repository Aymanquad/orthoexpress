import React, { useState } from 'react'
import { formatPrice } from '../../data/products'
import { useCart } from '../../context/CartContext'
import { useLanguage } from '../../context/LanguageContext'
import { getProductField } from '../../i18n/products'
import ProductInfoTooltip from './ProductInfoTooltip'
import './ProductCard.css'

const ProductCard = ({ product }) => {
  const { t, lang } = useLanguage()
  const { addToCart } = useCart()
  const [justAdded, setJustAdded] = useState(false)
  const productName = getProductField(product, 'name', lang)

  const handleAddToCart = (e) => {
    e.preventDefault()
    e.stopPropagation()
    addToCart(product.id, 1)
    setJustAdded(true)
    window.setTimeout(() => setJustAdded(false), 1800)
  }

  const imageWrapClass = [
    'product-card-image-wrap',
    product.imageVariant ? `product-card-image-wrap--${product.imageVariant}` : '',
  ]
    .filter(Boolean)
    .join(' ')

  return (
    <article className="product-card">
      <div className={imageWrapClass}>
        <ProductInfoTooltip product={product} />
        <img
          src={product.image}
          alt={productName}
          className="product-card-image"
          loading="lazy"
          width="500"
          height="500"
        />
      </div>
      <div className="product-card-body">
        <h3 className="product-card-title">{productName}</h3>
        <p className="product-card-price">{formatPrice(product.price, lang)}</p>
        <button
          type="button"
          className={`product-card-btn ${justAdded ? 'product-card-btn-added' : ''}`}
          onClick={handleAddToCart}
          aria-live="polite"
        >
          {justAdded ? t('shop.addedToCart') : t('shop.addToCart')}
        </button>
      </div>
    </article>
  )
}

export default ProductCard
