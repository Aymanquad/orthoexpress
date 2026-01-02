import React from 'react'
import { FaMapMarkerAlt, FaPhone, FaClock, FaDirections } from 'react-icons/fa'
import './Locations.css'

const Locations = () => {
  const locations = [
    {
      name: 'Main Clinic',
      address: '123 Medical Center Dr',
      city: 'City, State 12345',
      phone: '(123) 456-7890',
      hours: {
        weekdays: 'Monday - Friday: 8:00 AM - 6:00 PM',
        saturday: 'Saturday: 9:00 AM - 2:00 PM',
        sunday: 'Sunday: Closed'
      },
      mapLink: '#'
    },
    {
      name: 'Downtown Location',
      address: '456 Health Plaza',
      city: 'City, State 12345',
      phone: '(123) 456-7891',
      hours: {
        weekdays: 'Monday - Friday: 9:00 AM - 5:00 PM',
        saturday: 'Saturday: Closed',
        sunday: 'Sunday: Closed'
      },
      mapLink: '#'
    },
    {
      name: 'North Branch',
      address: '789 Wellness Blvd',
      city: 'City, State 12345',
      phone: '(123) 456-7892',
      hours: {
        weekdays: 'Monday - Friday: 8:00 AM - 4:00 PM',
        saturday: 'Saturday: 8:00 AM - 12:00 PM',
        sunday: 'Sunday: Closed'
      },
      mapLink: '#'
    }
  ]

  return (
    <div className="locations-page">
      <section className="locations-hero section">
        <div className="container">
          <h1 className="page-title">Our Locations</h1>
          <p className="page-subtitle">Multiple convenient locations to serve you</p>
        </div>
      </section>

      <section className="locations-content section">
        <div className="container">
          <div className="locations-grid">
            {locations.map((location, index) => (
              <div key={index} className="location-card-full">
                <h2 className="location-name-full">{location.name}</h2>
                <div className="location-details">
                  <div className="location-detail-item">
                    <FaMapMarkerAlt className="detail-icon" />
                    <div>
                      <p>{location.address}</p>
                      <p>{location.city}</p>
                    </div>
                  </div>
                  <div className="location-detail-item">
                    <FaPhone className="detail-icon" />
                    <a href={`tel:${location.phone}`}>{location.phone}</a>
                  </div>
                  <div className="location-detail-item">
                    <FaClock className="detail-icon" />
                    <div>
                      <p>{location.hours.weekdays}</p>
                      <p>{location.hours.saturday}</p>
                      <p>{location.hours.sunday}</p>
                    </div>
                  </div>
                  <div className="location-detail-item">
                    <FaDirections className="detail-icon" />
                    <a href={location.mapLink} target="_blank" rel="noopener noreferrer">
                      Get Directions
                    </a>
                  </div>
                </div>
                <div className="location-map-placeholder">
                  <span>Map View</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Locations

