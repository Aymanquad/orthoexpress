import React from 'react'
import { useLanguage } from '../context/LanguageContext'
import './SkipToMain.css'

const SkipToMain = () => {
  const { t } = useLanguage()
  return (
    <a href="#main-content" className="skip-to-main">
      {t('common.skipToMain')}
    </a>
  )
}

export default SkipToMain
