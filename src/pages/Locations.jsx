import React from 'react'
import { Link } from 'react-router-dom'
import { FaMapMarkerAlt, FaPhone, FaClock } from 'react-icons/fa'
import './Locations.css'

const Locations = () => {
  const locations = [
    {
      slug: 'los-angeles',
      name: 'Los Angeles',
      address: '8500 Beverly Boulevard, Suite 450',
      city: 'Los Angeles, CA 90048',
      phone: '(323) 655-8450',
      hours: 'Mon - Fri: 9 am to 5 pm'
    },
    {
      slug: 'london',
      name: 'London',
      address: '123 Harley Street',
      city: 'London, UK W1G 6AX',
      phone: '+44 20 7935 5555',
      hours: 'Mon - Fri: 9 am to 5 pm'
    },
    {
      slug: 'berlin',
      name: 'Berlin',
      address: 'Friedrichstraße 123',
      city: '10117 Berlin, Germany',
      phone: '+49 30 1234 5678',
      hours: 'Mon - Fri: 9 am to 5 pm'
    }
  ]

  return (
    <div className="locations-page">
      <section className="locations-hero section">
        <div className="container">
          <span className="locations-label">CONTACT US</span>
          <h1 className="page-title">Locations</h1>
        </div>
      </section>

      <section className="locations-content section">
        <div className="container">
          <div className="locations-grid">
            {locations.map((location) => (
              <Link 
                key={location.slug}
                to={`/locations/${location.slug}`}
                className="location-card-full"
              >
                <div className="location-card-icon">
                  <FaMapMarkerAlt />
                </div>
                <div className="location-card-content">
                  <h2 className="location-name-full">{location.name}</h2>
                  <p className="location-address">{location.address}</p>
                  <p className="location-city">{location.city}</p>
                  <div className="location-contact-info">
                    <div className="location-contact-item">
                      <FaPhone className="contact-item-icon" />
                      <span>{location.phone}</span>
                    </div>
                    <div className="location-contact-item">
                      <FaClock className="contact-item-icon" />
                      <span>{location.hours}</span>
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Locations

