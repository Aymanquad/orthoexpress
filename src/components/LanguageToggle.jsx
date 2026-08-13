import React from 'react'
import { useLanguage } from '../context/LanguageContext'
import './LanguageToggle.css'

const LanguageToggle = () => {
  const { lang, setLang, t } = useLanguage()

  return (
    <div className="lang-toggle" role="group" aria-label={t('nav.language')}>
      <button
        type="button"
        className={lang === 'en' ? 'active' : ''}
        onClick={() => setLang('en')}
        aria-pressed={lang === 'en'}
      >
        EN
      </button>
      <button
        type="button"
        className={lang === 'es' ? 'active' : ''}
        onClick={() => setLang('es')}
        aria-pressed={lang === 'es'}
      >
        ES
      </button>
    </div>
  )
}

export default LanguageToggle
