import React from 'react'
import './FormFeedback.css'

const FormFeedback = ({ type, message }) => {
  if (!message) return null

  return (
    <div className={`form-feedback form-feedback-${type}`} role="alert">
      {message}
    </div>
  )
}

export default FormFeedback
