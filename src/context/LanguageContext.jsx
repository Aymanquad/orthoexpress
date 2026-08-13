import React, { createContext, useContext, useEffect, useMemo, useState } from 'react'
import { translations } from '../i18n/translations'
import { localize } from '../i18n/localize'

const LanguageContext = createContext(null)
const STORAGE_KEY = 'orthoexpress_lang'

export function LanguageProvider({ children }) {
  const [lang, setLangState] = useState(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY)
      return saved === 'es' ? 'es' : 'en'
    } catch {
      return 'en'
    }
  })

  useEffect(() => {
    document.documentElement.lang = lang === 'es' ? 'es' : 'en'
    try {
      localStorage.setItem(STORAGE_KEY, lang)
    } catch {
      /* ignore */
    }
  }, [lang])

  const setLang = (next) => {
    setLangState(next === 'es' ? 'es' : 'en')
  }

  const toggleLang = () => {
    setLangState((prev) => (prev === 'en' ? 'es' : 'en'))
  }

  const t = useMemo(() => {
    const dict = translations[lang] || translations.en
    return (key, fallback = '') => {
      if (!key) return fallback
      const value = key.split('.').reduce((acc, part) => {
        if (acc && typeof acc === 'object' && part in acc) return acc[part]
        return undefined
      }, dict)
      if (value !== undefined && value !== null) return value
      const enValue = key.split('.').reduce((acc, part) => {
        if (acc && typeof acc === 'object' && part in acc) return acc[part]
        return undefined
      }, translations.en)
      return enValue !== undefined && enValue !== null ? enValue : fallback || key
    }
  }, [lang])

  const l = useMemo(() => (value) => localize(value, lang), [lang])

  const value = useMemo(
    () => ({ lang, setLang, toggleLang, t, l, isSpanish: lang === 'es' }),
    [lang, t, l]
  )

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>
}

export function useLanguage() {
  const ctx = useContext(LanguageContext)
  if (!ctx) {
    throw new Error('useLanguage must be used within LanguageProvider')
  }
  return ctx
}
