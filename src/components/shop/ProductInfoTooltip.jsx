import React, { useId, useState } from 'react'
import { FaInfo, FaStar } from 'react-icons/fa'
import { useProductUnitsSold } from '../../hooks/useProductStats'
import { useLanguage } from '../../context/LanguageContext'
import { getProductField, getProductReviewField } from '../../i18n/products'
import './ProductInfoTooltip.css'

const ProductInfoTooltip = ({ product }) => {
  const { t, lang } = useLanguage()
  const [isOpen, setIsOpen] = useState(false)
  const tooltipId = useId()
  const unitsSold = useProductUnitsSold(product.id, product.baseUnitsSold || 0)
  const productName = getProductField(product, 'name', lang)
  const highlights = getProductField(product, 'highlights', lang)
  const reviewText = getProductReviewField(product, 'text', lang)
  const reviewAuthor = getProductReviewField(product, 'author', lang)

  const toggle = (e) => {
    e.preventDefault()
    e.stopPropagation()
    setIsOpen((prev) => !prev)
  }

  return (
    <div
      className="product-info"
      onMouseEnter={() => setIsOpen(true)}
      onMouseLeave={() => setIsOpen(false)}
    >
      <button
        type="button"
        className="product-info-btn"
        onClick={toggle}
        aria-label={t('shop.moreInfoAbout').replace('{name}', productName)}
        aria-expanded={isOpen}
        aria-describedby={isOpen ? tooltipId : undefined}
      >
        <FaInfo aria-hidden="true" />
      </button>

      {isOpen && (
        <div id={tooltipId} className="product-info-tooltip" role="tooltip">
          <p className="product-info-sold">
            <strong>{unitsSold.toLocaleString(lang === 'es' ? 'es-US' : 'en-US')}</strong> {t('shop.bought')}
          </p>

          {highlights?.length > 0 && (
            <ul className="product-info-highlights">
              {highlights.slice(0, 3).map((point) => (
                <li key={point}>{point}</li>
              ))}
            </ul>
          )}

          {product.review && (
            <div className="product-info-review">
              <div
                className="product-info-rating"
                aria-label={t('shop.starRating').replace('{rating}', product.review.rating)}
              >
                {Array.from({ length: 5 }).map((_, index) => (
                  <FaStar
                    key={index}
                    className={index < Math.round(product.review.rating) ? 'filled' : ''}
                    aria-hidden="true"
                  />
                ))}
                <span>{product.review.rating.toFixed(1)}</span>
              </div>
              <p className="product-info-review-text">"{reviewText}"</p>
              <p className="product-info-review-author">
                — {reviewAuthor} ({t('shop.demoReview')})
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default ProductInfoTooltip
