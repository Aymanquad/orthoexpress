import React from 'react'
import { Link } from 'react-router-dom'
import { useLanguage } from '../context/LanguageContext'
import './ErrorBoundary.css'

function ErrorBoundaryFallback() {
  const { t } = useLanguage()

  return (
    <div className="error-boundary">
      <div className="error-boundary-content">
        <h1>{t('pages.errorBoundary.title')}</h1>
        <p>{t('pages.errorBoundary.message')}</p>
        <div className="error-boundary-actions">
          <button type="button" className="btn btn-primary" onClick={() => window.location.reload()}>
            {t('pages.errorBoundary.refresh')}
          </button>
          <Link to="/" className="btn btn-outline">
            {t('pages.errorBoundary.goHome')}
          </Link>
        </div>
      </div>
    </div>
  )
}

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false }
  }

  static getDerivedStateFromError() {
    return { hasError: true }
  }

  render() {
    if (this.state.hasError) {
      return <ErrorBoundaryFallback />
    }

    return this.props.children
  }
}

export default ErrorBoundary
