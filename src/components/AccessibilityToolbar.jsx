import React, { useEffect, useState } from 'react'
import {
  FaUniversalAccess,
  FaPlus,
  FaMinus,
  FaAdjust,
  FaLink,
  FaUndo,
  FaTimes,
} from 'react-icons/fa'
import { useLanguage } from '../context/LanguageContext'
import './AccessibilityToolbar.css'

const STORAGE_KEY = 'orthoexpress_a11y'

const AccessibilityToolbar = () => {
  const { t } = useLanguage()
  const [open, setOpen] = useState(false)
  const [fontStep, setFontStep] = useState(0)
  const [highContrast, setHighContrast] = useState(false)
  const [highlightLinks, setHighlightLinks] = useState(false)

  useEffect(() => {
    try {
      const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}')
      if (typeof saved.fontStep === 'number') setFontStep(saved.fontStep)
      if (saved.highContrast) setHighContrast(true)
      if (saved.highlightLinks) setHighlightLinks(true)
    } catch {
      /* ignore */
    }
  }, [])

  useEffect(() => {
    document.documentElement.style.setProperty('--a11y-font-scale', String(1 + fontStep * 0.08))
    document.body.classList.toggle('a11y-high-contrast', highContrast)
    document.body.classList.toggle('a11y-highlight-links', highlightLinks)
    try {
      localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify({ fontStep, highContrast, highlightLinks })
      )
    } catch {
      /* ignore */
    }
  }, [fontStep, highContrast, highlightLinks])

  const reset = () => {
    setFontStep(0)
    setHighContrast(false)
    setHighlightLinks(false)
  }

  return (
    <div className="a11y-toolbar">
      {open && (
        <div className="a11y-panel" role="dialog" aria-label={t('a11y.title')}>
          <div className="a11y-panel-head">
            <strong>{t('a11y.title')}</strong>
            <button type="button" onClick={() => setOpen(false)} aria-label={t('common.close')}>
              <FaTimes />
            </button>
          </div>
          <button type="button" onClick={() => setFontStep((s) => Math.min(3, s + 1))}>
            <FaPlus /> {t('a11y.increaseFont')}
          </button>
          <button type="button" onClick={() => setFontStep((s) => Math.max(-1, s - 1))}>
            <FaMinus /> {t('a11y.decreaseFont')}
          </button>
          <button
            type="button"
            className={highContrast ? 'active' : ''}
            onClick={() => setHighContrast((v) => !v)}
          >
            <FaAdjust /> {t('a11y.highContrast')}
          </button>
          <button
            type="button"
            className={highlightLinks ? 'active' : ''}
            onClick={() => setHighlightLinks((v) => !v)}
          >
            <FaLink /> {t('a11y.highlightLinks')}
          </button>
          <button type="button" onClick={reset}>
            <FaUndo /> {t('a11y.reset')}
          </button>
        </div>
      )}
      <button
        type="button"
        className="a11y-fab"
        aria-label={t('a11y.open')}
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
      >
        <FaUniversalAccess />
      </button>
    </div>
  )
}

export default AccessibilityToolbar
