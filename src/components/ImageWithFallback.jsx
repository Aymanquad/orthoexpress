import React, { useEffect, useState } from 'react'

const ImageWithFallback = ({ src, fallback, alt = '', ...props }) => {
  const [current, setCurrent] = useState(src)

  useEffect(() => {
    setCurrent(src)
  }, [src])

  return (
    <img
      src={current}
      alt={alt}
      onError={() => {
        if (fallback && current !== fallback) setCurrent(fallback)
      }}
      {...props}
    />
  )
}

export default ImageWithFallback
