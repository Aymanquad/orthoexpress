import React from 'react'
import { FaUsers, FaUserMd, FaHeart, FaHandsHelping } from 'react-icons/fa'
import './Stats.css'

const Stats = () => {
  const stats = [
    {
      icon: <FaUsers />,
      number: '150K +',
      label: 'Happy Patients'
    },
    {
      icon: <FaUsers />,
      number: '200K +',
      label: 'Patients Served'
    },
    {
      icon: <FaUserMd />,
      number: '56+',
      label: 'Professional Nurses'
    },
    {
      icon: <FaHandsHelping />,
      number: '308',
      label: 'Active Volunteers'
    }
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

