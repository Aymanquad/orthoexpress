import React from 'react'
import ImageWithFallback from './ImageWithFallback'
import './PageHeroMedia.css'

/**
 * Smart hero background — layout adapts to image aspect ratio:
 * photo (landscape cover), product (square/contain right), portrait, compact (low-res)
 */
const PageHeroMedia = ({ src, fallback, alt = '', layout = 'photo' }) => {
  if (!src) return null

  return (
    <div className={`page-hero__media page-hero__media--${layout}`}>
      <ImageWithFallback
        src={src}
        fallback={fallback}
        alt={alt}
        className="page-hero__image"
      />
      <div className="page-hero__overlay" aria-hidden="true" />
    </div>
  )
}

export default PageHeroMedia
