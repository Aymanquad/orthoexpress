import { useCallback, useEffect, useState } from 'react'
import { getProductUnitsSold } from '../utils/orders'
import { PRODUCT_STATS_UPDATED_EVENT } from '../utils/orders'

export function useProductUnitsSold(productId, baseUnitsSold = 0) {
  const [unitsSold, setUnitsSold] = useState(() =>
    getProductUnitsSold(productId, baseUnitsSold)
  )

  const refresh = useCallback(() => {
    setUnitsSold(getProductUnitsSold(productId, baseUnitsSold))
  }, [productId, baseUnitsSold])

  useEffect(() => {
    refresh()

    const handleUpdate = () => refresh()
    window.addEventListener(PRODUCT_STATS_UPDATED_EVENT, handleUpdate)
    window.addEventListener('storage', handleUpdate)

    return () => {
      window.removeEventListener(PRODUCT_STATS_UPDATED_EVENT, handleUpdate)
      window.removeEventListener('storage', handleUpdate)
    }
  }, [refresh])

  return unitsSold
}
