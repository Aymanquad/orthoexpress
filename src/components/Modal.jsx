import React, { useEffect, useRef } from 'react'
import { FaCheckCircle, FaExclamationCircle, FaExclamationTriangle, FaTimes } from 'react-icons/fa'
import { useLanguage } from '../context/LanguageContext'
import './Modal.css'

const ICONS = {
  success: FaCheckCircle,
  error: FaExclamationCircle,
  warning: FaExclamationTriangle,
  info: FaExclamationCircle,
}

const Modal = ({
  isOpen,
  onClose,
  type = 'info',
  title,
  message,
  children,
  primaryLabel,
  onPrimary,
  secondaryLabel,
  onSecondary,
}) => {
  const { t } = useLanguage()
  const closeBtnRef = useRef(null)
  const resolvedPrimaryLabel = primaryLabel ?? t('pages.modal.ok')

  useEffect(() => {
    if (!isOpen) return undefined

    const handleKeyDown = (e) => {
      if (e.key === 'Escape') onClose()
    }

    document.body.style.overflow = 'hidden'
    document.addEventListener('keydown', handleKeyDown)
    closeBtnRef.current?.focus()

    return () => {
      document.body.style.overflow = ''
      document.removeEventListener('keydown', handleKeyDown)
    }
  }, [isOpen, onClose])

  if (!isOpen) return null

  const Icon = ICONS[type] || ICONS.info

  const handlePrimary = () => {
    if (onPrimary) onPrimary()
    else onClose()
  }

  return (
    <div className="modal-overlay" onClick={onClose} role="presentation">
      <div
        className={`modal-dialog modal-${type}`}
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-title"
        aria-describedby="modal-message"
        onClick={(e) => e.stopPropagation()}
      >
        <button
          type="button"
          className="modal-close"
          onClick={onClose}
          aria-label={t('pages.modal.closeDialog')}
          ref={closeBtnRef}
        >
          <FaTimes />
        </button>

        <div className={`modal-icon modal-icon-${type}`}>
          <Icon aria-hidden="true" />
        </div>

        {title && (
          <h2 id="modal-title" className="modal-title">
            {title}
          </h2>
        )}

        {message && (
          <div id="modal-message" className="modal-message">
            {Array.isArray(message) ? (
              <ul className="modal-error-list">
                {message.map((line, i) => (
                  <li key={i}>{line}</li>
                ))}
              </ul>
            ) : typeof message === 'string' ? (
              message.split('\n').map((line, i) => (
                <p key={i}>{line}</p>
              ))
            ) : (
              message
            )}
          </div>
        )}

        {children}

        <div className="modal-actions">
          {secondaryLabel && (
            <button type="button" className="btn btn-outline modal-btn" onClick={onSecondary || onClose}>
              {secondaryLabel}
            </button>
          )}
          <button type="button" className="btn btn-primary modal-btn" onClick={handlePrimary}>
            {resolvedPrimaryLabel}
          </button>
        </div>
      </div>
    </div>
  )
}

export default Modal
