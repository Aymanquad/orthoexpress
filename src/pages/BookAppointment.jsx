import React, { useState } from 'react'
import { FaCalendarAlt, FaClock, FaUser, FaPhone, FaEnvelope } from 'react-icons/fa'
import './BookAppointment.css'

const BookAppointment = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    preferredDate: '',
    preferredTime: '',
    reason: '',
    location: ''
  })

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    // Handle appointment booking here
    alert('Thank you! We will contact you shortly to confirm your appointment.')
    setFormData({
      name: '',
      email: '',
      phone: '',
      preferredDate: '',
      preferredTime: '',
      reason: '',
      location: ''
    })
  }

  return (
    <div className="book-appointment-page">
      <section className="appointment-hero section">
        <div className="container">
          <h1 className="page-title">Book an Appointment</h1>
          <p className="page-subtitle">Schedule your visit with our orthopedic specialists</p>
        </div>
      </section>

      <section className="appointment-content section">
        <div className="container">
          <div className="appointment-info">
            <h2>Walk-in Appointments Available</h2>
            <p>
              While you can schedule an appointment in advance, we also welcome walk-in patients. 
              No appointment is necessary - simply visit us during our business hours.
            </p>
            <div className="info-cards">
              <div className="info-card">
                <FaClock className="info-icon" />
                <h3>Same Day Service</h3>
                <p>Get seen on the same day you visit</p>
              </div>
              <div className="info-card">
                <FaCalendarAlt className="info-icon" />
                <h3>Flexible Scheduling</h3>
                <p>Choose a time that works for you</p>
              </div>
            </div>
          </div>

          <div className="appointment-form-container">
            <h2>Request an Appointment</h2>
            <p className="form-subtitle">
              Fill out the form below and we'll contact you to confirm your appointment time.
            </p>
            <form className="appointment-form" onSubmit={handleSubmit}>
              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="name">
                    <FaUser /> Full Name *
                  </label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="phone">
                    <FaPhone /> Phone Number *
                  </label>
                  <input
                    type="tel"
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    required
                  />
                </div>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="email">
                    <FaEnvelope /> Email *
                  </label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="location">Preferred Location</label>
                  <select
                    id="location"
                    name="location"
                    value={formData.location}
                    onChange={handleChange}
                  >
                    <option value="">Select a location</option>
                    <option value="main">Main Clinic</option>
                    <option value="downtown">Downtown Location</option>
                    <option value="north">North Branch</option>
                  </select>
                </div>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="preferredDate">Preferred Date *</label>
                  <input
                    type="date"
                    id="preferredDate"
                    name="preferredDate"
                    value={formData.preferredDate}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="preferredTime">Preferred Time</label>
                  <select
                    id="preferredTime"
                    name="preferredTime"
                    value={formData.preferredTime}
                    onChange={handleChange}
                  >
                    <option value="">Select a time</option>
                    <option value="morning">Morning (8AM - 12PM)</option>
                    <option value="afternoon">Afternoon (12PM - 4PM)</option>
                    <option value="evening">Evening (4PM - 6PM)</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="reason">Reason for Visit</label>
                <textarea
                  id="reason"
                  name="reason"
                  rows="4"
                  value={formData.reason}
                  onChange={handleChange}
                  placeholder="Please describe your condition or reason for the visit..."
                />
              </div>

              <button type="submit" className="btn btn-primary btn-large">
                Request Appointment
              </button>
            </form>
          </div>
        </div>
      </section>
    </div>
  )
}

export default BookAppointment

