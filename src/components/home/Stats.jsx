import React from 'react'
import { FaUsers, FaUserMd, FaHandsHelping } from 'react-icons/fa'
import { useLanguage } from '../../context/LanguageContext'
import './Stats.css'

const Stats = () => {
  const { t } = useLanguage()

  const stats = [
    { icon: <FaUsers />, number: '150K +', label: t('home.stats.happyPatients') },
    { icon: <FaUsers />, number: '200K +', label: t('home.stats.patientsServed') },
    { icon: <FaUserMd />, number: '56+', label: t('home.stats.nurses') },
    { icon: <FaHandsHelping />, number: '308', label: t('home.stats.volunteers') },
  ]

  return (
    <section className="stats section">
      <div className="container">
        <div className="stats-grid">
          {stats.map((stat, index) => (
            <div key={index} className="stat-card">
              <div className="stat-icon">{stat.icon}</div>
              <div className="stat-number">{stat.number}</div>
              <div className="stat-label">{stat.label}</div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default Stats
