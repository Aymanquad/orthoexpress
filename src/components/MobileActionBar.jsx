import React, { useEffect } from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaCalendarPlus } from 'react-icons/fa'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import './MobileActionBar.css'

const MobileActionBar = () => {
  const { headquarters } = CLINIC
  const { t } = useLanguage()

  useEffect(() => {
    document.body.classList.add('has-mobile-action-bar')
    return () => document.body.classList.remove('has-mobile-action-bar')
  }, [])

  return (
    <div className="mobile-action-bar" aria-label={t('a11y.quickActions')}>
      <a href={toTelLink(headquarters.phone)} className="mobile-action-btn mobile-action-call">
        <FaPhone />
        <span>{t('common.call')}</span>
      </a>
      <Link to="/book-appointment" className="mobile-action-btn mobile-action-book">
        <FaCalendarPlus />
        <span>{t('common.book')}</span>
      </Link>
    </div>
  )
}

export default MobileActionBar
