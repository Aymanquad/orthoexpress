import React from 'react'
import ImageWithFallback from './ImageWithFallback'
import './PageBodyMedia.css'

/**
 * Body figure — square | pack | portrait | wide
 * Uses cover for clinical fills; contain only for packshots.
 */
const PageBodyMedia = ({ src, fallback, alt = '', layout = 'square' }) => {
  if (!src) return null

  const safeLayout = ['square', 'pack', 'portrait', 'wide'].includes(layout)
    ? layout
    : 'square'

  return (
    <figure className={`page-body-media page-body-media--${safeLayout}`}>
      <ImageWithFallback
        src={src}
        fallback={fallback}
        alt={alt}
        loading="lazy"
      />
    </figure>
  )
}

export default PageBodyMedia
