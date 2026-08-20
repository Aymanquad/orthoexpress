import React, { useCallback, useEffect, useRef, useState } from 'react'
import { FaChevronLeft, FaChevronRight } from 'react-icons/fa'
import { EHR_SYSTEMS } from '../../data/ehrs'
import { useLanguage } from '../../context/LanguageContext'
import './EhrIntegrations.css'

const AUTO_MS = 4200

function getOffset(i, index, total) {
  let offset = i - index
  if (offset > total / 2) offset -= total
  if (offset < -total / 2) offset += total
  return offset
}

const EhrIntegrations = () => {
  const { t, lang } = useLanguage()
  const [index, setIndex] = useState(0)
  const [paused, setPaused] = useState(false)
  const touchX = useRef(null)
  const total = EHR_SYSTEMS.length
  const active = EHR_SYSTEMS[index]

  const goTo = useCallback(
    (next) => {
      setIndex(((next % total) + total) % total)
    },
    [total]
  )

  useEffect(() => {
    if (paused || total < 2) return undefined
    const id = window.setInterval(() => {
      setIndex((prev) => (prev + 1) % total)
    }, AUTO_MS)
    return () => window.clearInterval(id)
  }, [paused, total, index])

  const highlight = active.highlight[lang] || active.highlight.en
  const country = active.country[lang] || active.country.en

  const onTouchStart = (e) => {
    touchX.current = e.changedTouches[0].clientX
  }

  const onTouchEnd = (e) => {
    if (touchX.current == null) return
    const delta = e.changedTouches[0].clientX - touchX.current
    touchX.current = null
    if (Math.abs(delta) < 40) return
    goTo(index + (delta < 0 ? 1 : -1))
  }

  return (
    <section className="ehr-integrations" aria-labelledby="ehr-integrations-title">
      <div className="ehr-integrations-glow" aria-hidden="true" />

      <div className="container">
        <header className="ehr-integrations-header">
          <p className="ehr-integrations-eyebrow">{t('home.ehr.eyebrow')}</p>
          <h2 id="ehr-integrations-title" className="ehr-integrations-title">
            {t('home.ehr.title')}
          </h2>
          <p className="ehr-integrations-subtitle">{t('home.ehr.subtitle')}</p>
        </header>

        <div
          className="ehr-spotlight"
          onMouseEnter={() => setPaused(true)}
          onMouseLeave={() => setPaused(false)}
          onFocusCapture={() => setPaused(true)}
          onBlurCapture={(e) => {
            if (!e.currentTarget.contains(e.relatedTarget)) setPaused(false)
          }}
        >
          <button
            type="button"
            className="ehr-spotlight-nav ehr-spotlight-nav--prev"
            onClick={() => goTo(index - 1)}
            aria-label={t('home.ehr.prev')}
          >
            <FaChevronLeft aria-hidden="true" />
          </button>

          <div
            className="ehr-spotlight-stage"
            aria-live="polite"
            onTouchStart={onTouchStart}
            onTouchEnd={onTouchEnd}
          >
            {EHR_SYSTEMS.map((ehr, i) => {
              const offset = getOffset(i, index, total)
              if (Math.abs(offset) > 3) return null

              const isActive = offset === 0
              const clamped = Math.max(-2, Math.min(2, offset))
              const far = Math.abs(offset) > 2

              return (
                <button
                  key={ehr.id}
                  type="button"
                  className={`ehr-card${isActive ? ' is-active' : ''}${far ? ' is-far' : ''}`}
                  data-offset={clamped}
                  tabIndex={isActive ? 0 : -1}
                  aria-current={isActive ? 'true' : undefined}
                  aria-hidden={far ? 'true' : undefined}
                  aria-label={ehr.name}
                  onClick={() => {
                    if (!isActive && !far) goTo(i)
                  }}
                >
                  <span className="ehr-card-face">
                    <span className="ehr-card-brand" aria-hidden="true">
                      <span className="ehr-card-mark">{ehr.monogram}</span>
                    </span>
                    <span className="ehr-card-body">
                      <span className="ehr-card-name">{ehr.name}</span>
                      {isActive ? (
                        <>
                          <span className="ehr-card-developer">{ehr.developer}</span>
                          <span className="ehr-card-region">{country}</span>
                        </>
                      ) : null}
                    </span>
                  </span>
                </button>
              )
            })}
          </div>

          <button
            type="button"
            className="ehr-spotlight-nav ehr-spotlight-nav--next"
            onClick={() => goTo(index + 1)}
            aria-label={t('home.ehr.next')}
          >
            <FaChevronRight aria-hidden="true" />
          </button>
        </div>

        <div className="ehr-spotlight-copy" key={active.id}>
          <p className="ehr-spotlight-highlight">{highlight}</p>
          <p className="ehr-spotlight-count">
            {index + 1}
            <span>/</span>
            {total}
          </p>
        </div>

        <div className="ehr-progress" aria-hidden="true">
          <span
            key={`${active.id}-bar`}
            className={`ehr-progress-bar${paused ? ' is-paused' : ''}`}
          />
        </div>
      </div>
    </section>
  )
}

export default EhrIntegrations
