import React, { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useLanguage } from '../../../context/LanguageContext'
import { hasNativeBridge, postToNative } from '../../../lib/nativeBridge'
import { BODY_TOPICS, getHotspot, getPrimaryHotspotId, isTopicActive } from './jointHotspots'
import './SkeletonViewer.css'

function prefersReducedMotion() {
  return typeof window !== 'undefined' && window.matchMedia('(prefers-reduced-motion: reduce)').matches
}

function setLeaderLine(line, glow, fromDot, fromRing, toDot, from, to, key, animate) {
  if (!line || !from || !to) {
    if (line) {
      line.style.display = 'none'
      line.dataset.key = ''
    }
    if (glow) glow.style.display = 'none'
    if (fromDot) fromDot.style.display = 'none'
    if (fromRing) fromRing.style.display = 'none'
    if (toDot) toDot.style.display = 'none'
    return
  }

  const x1 = from.x
  const y1 = from.y
  const x2 = to.x
  const y2 = to.y
  // Gentle quadratic curve — more designed than a ruler-straight segment.
  const cx = x1 + (x2 - x1) * 0.42
  const cy = y1 + (y2 - y1) * 0.12 - Math.min(36, Math.abs(x2 - x1) * 0.12)
  const d = `M ${x1} ${y1} Q ${cx} ${cy} ${x2} ${y2}`

  line.style.display = 'block'
  line.setAttribute('d', d)
  const length = Math.max(1, typeof line.getTotalLength === 'function' ? line.getTotalLength() : Math.hypot(x2 - x1, y2 - y1))
  line.setAttribute('stroke-dasharray', String(length))

  if (glow) {
    glow.style.display = 'block'
    glow.setAttribute('d', d)
    glow.setAttribute('stroke-dasharray', String(length))
  }

  if (fromDot) {
    fromDot.style.display = 'block'
    fromDot.setAttribute('cx', String(x1))
    fromDot.setAttribute('cy', String(y1))
  }

  if (fromRing) {
    fromRing.style.display = 'block'
    fromRing.setAttribute('cx', String(x1))
    fromRing.setAttribute('cy', String(y1))
  }

  if (toDot) {
    toDot.style.display = 'block'
    toDot.setAttribute('cx', String(x2))
    toDot.setAttribute('cy', String(y2))
  }

  const keyChanged = line.dataset.key !== key
  if (keyChanged) line.dataset.key = key

  if (keyChanged && animate) {
    line.style.opacity = '0'
    line.style.transition = 'none'
    line.setAttribute('stroke-dashoffset', String(length))
    if (glow) {
      glow.style.opacity = '0'
      glow.style.transition = 'none'
      glow.setAttribute('stroke-dashoffset', String(length))
    }
    if (fromDot) {
      fromDot.style.opacity = '0'
      fromDot.style.transition = 'none'
    }
    if (fromRing) {
      fromRing.style.opacity = '0'
      fromRing.style.transition = 'none'
      fromRing.classList.remove('is-live')
    }
    if (toDot) {
      toDot.style.opacity = '0'
      toDot.style.transition = 'none'
    }
    line.getBoundingClientRect()
    line.style.transition =
      'stroke-dashoffset 0.42s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.28s ease-out'
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (glow) {
      glow.style.transition =
        'stroke-dashoffset 0.5s cubic-bezier(0.22, 1, 0.36, 1) 0.03s, opacity 0.32s ease-out 0.03s'
      glow.setAttribute('stroke-dashoffset', '0')
      glow.style.opacity = '1'
    }
    if (fromDot) {
      fromDot.style.transition = 'opacity 0.24s ease-out 0.28s'
      fromDot.style.opacity = '1'
    }
    if (fromRing) {
      fromRing.style.transition = 'opacity 0.28s ease-out 0.32s'
      fromRing.style.opacity = '1'
      fromRing.classList.add('is-live')
    }
    if (toDot) {
      toDot.style.transition = 'opacity 0.24s ease-out 0.34s'
      toDot.style.opacity = '1'
    }
  } else if (keyChanged) {
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (glow) {
      glow.setAttribute('stroke-dashoffset', '0')
      glow.style.opacity = '1'
    }
    if (fromDot) fromDot.style.opacity = '1'
    if (fromRing) {
      fromRing.style.opacity = '1'
      fromRing.classList.add('is-live')
    }
    if (toDot) toDot.style.opacity = '1'
  } else {
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (glow) {
      glow.setAttribute('stroke-dashoffset', '0')
      glow.style.opacity = '1'
    }
    if (fromDot) fromDot.style.opacity = '1'
    if (fromRing) {
      fromRing.style.opacity = '1'
      fromRing.classList.add('is-live')
    }
    if (toDot) toDot.style.opacity = '1'
  }
}

const SkeletonViewer = ({ embed = false, stageOnly = false }) => {
  const { t } = useLanguage()
  const [params] = useSearchParams()
  const debugHotspots = params.get('debugHotspots') === 'true'
  // Inside the app's WebView these actions must hand off to native screens
  // instead of navigating the embedded page.
  const routeToNative = embed && hasNativeBridge()

  const sectionRef = useRef(null)
  const layoutRef = useRef(null)
  const stageRef = useRef(null)
  const canvasRef = useRef(null)
  const panelAnchorRef = useRef(null)
  const viewerRef = useRef(null)
  const leaderRef = useRef(null)
  const leaderGlowRef = useRef(null)
  const leaderDotRef = useRef(null)
  const leaderRingRef = useRef(null)
  const leaderEndDotRef = useRef(null)
  const selectedIdRef = useRef(null)

  const [active, setActive] = useState(false)
  const [ready, setReady] = useState(false)
  const [progress, setProgress] = useState(0)
  const [error, setError] = useState(false)
  const [hoveredId, setHoveredId] = useState(null)
  const [selectedId, setSelectedId] = useState(null)

  const activeId = selectedId || hoveredId
  const activeHotspot = activeId ? getHotspot(activeId) : null
  const labels = t('home.skeletonViewer.labels')
  const topics = t('home.skeletonViewer.topics')
  const injuries = activeHotspot && selectedId ? t(`home.skeletonViewer.injuries.${activeHotspot.region}`) : []
  const treatment = activeHotspot && selectedId ? t(`home.skeletonViewer.treatments.${activeHotspot.region}`) : ''
  selectedIdRef.current = selectedId

  const topicButtons = useMemo(
    () =>
      BODY_TOPICS.map((topic) => ({
        ...topic,
        label: topics?.[topic.id] || topic.id,
      })),
    [topics]
  )

  useEffect(() => {
    const node = sectionRef.current
    if (!node) return undefined
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) setActive(true)
      },
      { rootMargin: '280px 0px' }
    )
    observer.observe(node)
    return () => observer.disconnect()
  }, [])

  useEffect(() => {
    if (!active || !stageRef.current || !canvasRef.current) return undefined

    let cancelled = false
    const canvas = canvasRef.current
    const container = stageRef.current
    const animateLine = !prefersReducedMotion()

    const getCalloutPoint = () => {
      const layout = layoutRef.current
      const anchor = panelAnchorRef.current
      if (!layout || !anchor) return null
      const layoutBox = layout.getBoundingClientRect()
      const box = anchor.getBoundingClientRect()
      return {
        x: box.left - layoutBox.left,
        y: box.top - layoutBox.top + box.height / 2,
      }
    }

    const toLayoutPoint = (point) => {
      const layout = layoutRef.current
      const stage = stageRef.current
      if (!layout || !stage || !point?.visible) return null
      const layoutBox = layout.getBoundingClientRect()
      const stageBox = stage.getBoundingClientRect()
      return {
        x: stageBox.left - layoutBox.left + point.x,
        y: stageBox.top - layoutBox.top + point.y,
      }
    }

    ;(async () => {
      try {
        const { createSkeletonViewer } = await import('./createSkeletonViewer.js')
        if (cancelled) return
        const viewer = await createSkeletonViewer({
          canvas,
          container,
          debugHotspots,
          reducedMotion: prefersReducedMotion(),
          onProgress: (value) => {
            if (!cancelled) setProgress(value)
          },
          onHover: (id) => {
            if (!cancelled) setHoveredId(id)
          },
          onSelect: (id) => {
            if (cancelled) return
            setSelectedId(id)
            // The native shell renders its own callout, so it needs to know.
            if (embed) postToNative(`select:${id || ''}`)
          },
          onFrame: ({ hover, selected: selectedPoint }) => {
            const currentSelected = selectedIdRef.current
            const source = currentSelected ? selectedPoint : hover
            const from = toLayoutPoint(source)
            const to = getCalloutPoint()
            const key = currentSelected || hover?.id || ''
            setLeaderLine(
              leaderRef.current,
              leaderGlowRef.current,
              leaderDotRef.current,
              leaderRingRef.current,
              leaderEndDotRef.current,
              from,
              to,
              key,
              animateLine
            )
          },
        })
        if (cancelled) {
          viewer.dispose()
          return
        }
        viewerRef.current = viewer
        if (container.matches(':hover')) viewer.setStageHovered(true)
        setReady(true)
      } catch (err) {
        console.error('Skeleton viewer failed to load', err)
        if (!cancelled) setError(true)
      }
    })()

    return () => {
      cancelled = true
      viewerRef.current?.dispose()
      viewerRef.current = null
    }
  }, [active, debugHotspots, embed])

  // Lets the native shell drive selection from its own topic list.
  useEffect(() => {
    if (!embed) return undefined
    window.OrthoEmbed = {
      ...(window.OrthoEmbed || {}),
      select: (id) => viewerRef.current?.select(id || null),
    }
    return () => {
      if (window.OrthoEmbed) delete window.OrthoEmbed.select
    }
  }, [embed, ready])

  useEffect(() => {
    if (!ready || !stageRef.current) return
    viewerRef.current?.setVisible?.()
    if (stageRef.current.matches(':hover')) {
      viewerRef.current?.setStageHovered?.(true)
    }
  }, [ready])

  const onStageMouseEnter = () => viewerRef.current?.setStageHovered?.(true)
  const onStageMouseLeave = () => viewerRef.current?.setStageHovered?.(false)

  const closePanel = () => {
    viewerRef.current?.select(null)
  }

  const selectTopic = (topicId) => {
    const hotspotId = getPrimaryHotspotId(topicId)
    if (hotspotId) viewerRef.current?.select(hotspotId)
  }

  const stage = (
    <div
      className="skeleton-stage"
      ref={stageRef}
      onMouseEnter={onStageMouseEnter}
      onMouseLeave={onStageMouseLeave}
    >
      <div className="skeleton-stage-aura" aria-hidden="true" />
      <div className="skeleton-stage-grid" aria-hidden="true" />
      <canvas ref={canvasRef} className="skeleton-canvas" aria-label={t('home.skeletonViewer.canvasLabel')} />

      {active && !ready && !error && (
        <div className="skeleton-status" role="status">
          <span className="skeleton-status-ring" aria-hidden="true" />
          <p>{t('home.skeletonViewer.loading')}</p>
          <span className="skeleton-status-pct">{progress}%</span>
        </div>
      )}

      {error && (
        <div className="skeleton-status skeleton-status-error" role="alert">
          <p>{t('home.skeletonViewer.error')}</p>
        </div>
      )}

      <p className="skeleton-hint">{t('home.skeletonViewer.hint')}</p>
    </div>
  )

  // The native app supplies its own heading, callout and topic list, so the
  // embed ships the 3D stage alone.
  if (stageOnly) {
    return (
      <section className="skeleton-viewer skeleton-viewer-stage-only" ref={sectionRef}>
        {stage}
      </section>
    )
  }

  return (
    <section className="skeleton-viewer" ref={sectionRef} aria-labelledby="skeleton-viewer-title">
      <div className="container skeleton-viewer-wrap">
        <div
          className={`skeleton-layout ${selectedId ? 'is-open' : ''} ${hoveredId ? 'is-hover' : ''} ${ready ? 'is-ready' : ''}`}
          ref={layoutRef}
        >
          <svg className="skeleton-leaders" aria-hidden="true">
            <path ref={leaderGlowRef} className="skeleton-leader-glow" d="" fill="none" />
            <path ref={leaderRef} className="skeleton-leader-line" d="" fill="none" />
            <circle ref={leaderRingRef} className="skeleton-leader-ring" cx="0" cy="0" r="9" />
            <circle ref={leaderDotRef} className="skeleton-leader-dot" cx="0" cy="0" r="3.5" />
            <circle ref={leaderEndDotRef} className="skeleton-leader-end" cx="0" cy="0" r="3" />
          </svg>

          {/* Left: title + body-part buttons. Center: model. Right: injury detail panel. */}
          <div className="skeleton-sidebar">
            <header className="skeleton-viewer-header">
              <p className="skeleton-viewer-eyebrow">{t('home.skeletonViewer.eyebrow')}</p>
              <h2 id="skeleton-viewer-title" className="skeleton-viewer-title">
                {t('home.skeletonViewer.title')}
              </h2>
              <p className="skeleton-viewer-subtitle">{t('home.skeletonViewer.subtitle')}</p>
            </header>

            <nav className="skeleton-joint-nav" aria-label={t('home.skeletonViewer.navLabel')}>
              {topicButtons.map((topic) => (
                <button
                  key={topic.id}
                  type="button"
                  className={`skeleton-joint-chip ${isTopicActive(topic.id, selectedId) ? 'is-active' : ''}`}
                  onClick={() => selectTopic(topic.id)}
                >
                  {topic.label}
                </button>
              ))}
            </nav>
          </div>

          {stage}

          <aside className="skeleton-detail" aria-live="polite">
            <span className="skeleton-callout-anchor" ref={panelAnchorRef} />
            <div className="skeleton-callout">
              {!activeHotspot && <p className="skeleton-callout-idle">{t('home.skeletonViewer.idle')}</p>}
              {activeHotspot && (
                <div
                  key={`${activeHotspot.id}-${selectedId ? 'open' : 'hover'}`}
                  className={`skeleton-callout-panel ${selectedId ? 'is-selected' : 'is-preview'}`}
                >
                  <p className="skeleton-callout-kicker">{t('home.skeletonViewer.panelKicker')}</p>
                  <h3>{labels?.[activeHotspot.id]}</h3>
                  {selectedId ? (
                    <>
                      <p className="skeleton-callout-label">{t('home.skeletonViewer.injuriesLabel')}</p>
                      <ul className="skeleton-callout-list">
                        {(Array.isArray(injuries) ? injuries : []).map((item) => (
                          <li key={item}>{item}</li>
                        ))}
                      </ul>
                      <p className="skeleton-callout-label">{t('home.skeletonViewer.treatmentLabel')}</p>
                      <p className="skeleton-callout-copy">{treatment}</p>
                      <p className="skeleton-callout-actions">
                        {routeToNative ? (
                          <>
                            <button
                              type="button"
                              onClick={() => postToNative(`learn_more:${activeHotspot.slug}`)}
                            >
                              {t('common.learnMore')}
                            </button>
                            <button
                              type="button"
                              onClick={() => postToNative(`book_appointment:${activeHotspot.id}`)}
                            >
                              {t('common.bookAppointment')}
                            </button>
                          </>
                        ) : (
                          <>
                            <Link to={`/services/${activeHotspot.slug}`}>{t('common.learnMore')}</Link>
                            <Link to="/book-appointment">{t('common.bookAppointment')}</Link>
                          </>
                        )}
                        <button type="button" onClick={closePanel}>
                          {t('common.close')}
                        </button>
                      </p>
                    </>
                  ) : (
                    <p className="skeleton-callout-hint">{t('home.skeletonViewer.clickHint')}</p>
                  )}
                </div>
              )}
            </div>
          </aside>
        </div>

        <p className="skeleton-credit">{t('home.skeletonViewer.credit')}</p>
      </div>
    </section>
  )
}

export default SkeletonViewer
