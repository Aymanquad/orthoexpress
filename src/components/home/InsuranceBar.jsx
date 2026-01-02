import React from 'react'
import './InsuranceBar.css'

const InsuranceBar = () => {
  const insuranceProviders = [
    'ACPN',
    'AvMed',
    'AETNA',
    'Molina',
    'Cigna',
    'United Healthcare',
    'Coventry',
    'Florida Blue',
    'Simply Healthcare',
    'Medicare Gov',
    'Medicaid Gov'
  ]

  return (
    <section className="insurance-bar section">
      <div className="container">
        <h2 className="insurance-title">Insurance</h2>
        <p className="insurance-subtitle">
          We accept most insurance plans. Call your neighborhood Orthocare for center details.
        </p>
        <p className="insurance-note-bold">
          <strong>No insurance? No problem. We offer affordable cash pay options.</strong>
        </p>
        <div className="insurance-grid">
          {insuranceProviders.map((provider, index) => (
            <div key={index} className="insurance-card">
              <p className="insurance-name">{provider}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default InsuranceBar

