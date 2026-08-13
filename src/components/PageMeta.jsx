import { useEffect } from 'react'
import { CLINIC } from '../data'

const PageMeta = ({ title, description }) => {
  useEffect(() => {
    const fullTitle = title ? `${title} | ${CLINIC.name}` : `${CLINIC.name} — Expert Orthopedic Care`
    document.title = fullTitle

    let meta = document.querySelector('meta[name="description"]')
    if (!meta) {
      meta = document.createElement('meta')
      meta.name = 'description'
      document.head.appendChild(meta)
    }
    if (description) {
      meta.content = description
    }

    return () => {
      document.title = `${CLINIC.name} — Expert Orthopedic Care`
    }
  }, [title, description])

  return null
}

export default PageMeta
