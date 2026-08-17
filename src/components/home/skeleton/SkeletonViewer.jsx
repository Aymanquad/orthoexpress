import React, { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useLanguage } from '../../../context/LanguageContext'
import { JOINT_HOTSPOTS, getHotspot } from './jointHotspots'
import './SkeletonViewer.css'

function prefersReducedMotion() {
  return typeof window !== 'undefined' && window.matchMedia('(prefers-reduced-motion: reduce)').matches
}

function setLeaderLine(line, dot, from, to, key, animate) {
  if (!line || !from || !to) {
    if (line) {
      line.style.display = 'none'
      line.dataset.key = ''
    }
    if (dot) dot.style.display = 'none'
    return
  }

  const x1 = from.x
  const y1 = from.y
  const x2 = to.x
  const y2 = from.y
  const length = Math.max(1, Math.abs(x2 - x1))

  line.style.display = 'block'
  line.setAttribute('x1', String(x1))
  line.setAttribute('y1', String(y1))
  line.setAttribute('x2', String(x2))
  line.setAttribute('y2', String(y2))
  line.setAttribute('stroke-dasharray', String(length))

  if (dot) {
    dot.style.display = 'block'
    dot.setAttribute('cx', String(x1))
    dot.setAttribute('cy', String(y1))
  }

  const keyChanged = line.dataset.key !== key
  if (keyChanged) line.dataset.key = key

  if (keyChanged && animate) {
    line.style.opacity = '0'
    line.style.transition = 'none'
    line.setAttribute('stroke-dashoffset', String(length))
    if (dot) {
      dot.style.opacity = '0'
      dot.style.transition = 'none'
    }
    line.getBoundingClientRect()
    line.style.transition =
      'stroke-dashoffset 0.52s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.28s ease-out'
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (dot) {
      dot.style.transition = 'opacity 0.3s ease-out 0.14s'
      dot.style.opacity = '1'
    }
  } else if (keyChanged) {
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (dot) dot.style.opacity = '1'
  } else {
    line.setAttribute('stroke-dashoffset', '0')
    line.style.opacity = '1'
    if (dot) dot.style.opacity = '1'
  }
}

const SkeletonViewer = () => {
  const { t } = useLanguage()
  const [params] = useSearchParams()
  const debugHotspots = params.get('debugHotspots') === 'true'

  const sectionRef = useRef(null)
  const layoutRef = useRef(null)
  const stageRef = useRef(null)
  const canvasRef = useRef(null)
  const panelAnchorRef = useRef(null)
  const viewerRef = useRef(null)
  const leaderRef = useRef(null)
  const leaderDotRef = useRef(null)
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
  const injuries = activeHotspot && selectedId ? t(`home.skeletonViewer.injuries.${activeHotspot.region}`) : []
  const treatment = activeHotspot && selectedId ? t(`home.skeletonViewer.treatments.${activeHotspot.region}`) : ''
  selectedIdRef.current = selectedId

  const jointButtons = useMemo(
    () =>
      JOINT_HOTSPOTS.map((joint) => ({
        ...joint,
        label: labels?.[joint.id] || joint.id,
      })),
    [labels]
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
        x: box.right - layoutBox.left,
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
            if (!cancelled) setSelectedId(id)
          },
          onFrame: ({ hover, selected: selectedPoint }) => {
            const currentSelected = selectedIdRef.current
            const source = currentSelected ? selectedPoint : hover
            const from = toLayoutPoint(source)
            const to = getCalloutPoint()
            const key = currentSelected || hover?.id || ''
            setLeaderLine(leaderRef.current, leaderDotRef.current, from, to, key, animateLine)
          },
        })
        if (cancelled) {
          viewer.dispose()
          return
        }
        viewerRef.current = viewer
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
  }, [active, debugHotspots])

  useEffect(() => {
    const viewer = viewerRef.current
    if (!viewer || !sectionRef.current) return undefined
    const observer = new IntersectionObserver(
      ([entry]) => viewer.setVisible(entry.isIntersecting),
      { threshold: 0.05 }
    )
    observer.observe(sectionRef.current)
    return () => observer.disconnect()
  }, [ready])

  const closePanel = () => {
    viewerRef.current?.select(null)
  }

  const selectJoint = (id) => {
    viewerRef.current?.select(id)
  }

  return (
    <section className="skeleton-viewer" ref={sectionRef} aria-labelledby="skeleton-viewer-title">
      <div className="container skeleton-viewer-wrap">
        <header className="skeleton-viewer-header">
          <p className="skeleton-viewer-eyebrow">{t('home.skeletonViewer.eyebrow')}</p>
          <h2 id="skeleton-viewer-title" className="skeleton-viewer-title">
            {t('home.skeletonViewer.title')}
          </h2>
          <p className="skeleton-viewer-subtitle">{t('home.skeletonViewer.subtitle')}</p>
        </header>

        <div className={`skeleton-layout ${selectedId ? 'is-open' : ''} ${hoveredId ? 'is-hover' : ''}`} ref={layoutRef}>
          <svg className="skeleton-leaders" aria-hidden="true">
            <line ref={leaderRef} className="skeleton-leader-line" x1="0" y1="0" x2="0" y2="0" />
            <circle ref={leaderDotRef} className="skeleton-leader-dot" cx="0" cy="0" r="3.5" />
          </svg>

          <aside className="skeleton-callout" aria-live="polite">
            <span className="skeleton-callout-anchor" ref={panelAnchorRef} />
            {!activeHotspot && <p className="skeleton-callout-idle">{t('home.skeletonViewer.idle')}</p>}
            {activeHotspot && (
              <>
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
                      <Link to={`/services/${activeHotspot.slug}`}>{t('common.learnMore')} →</Link>
                      <Link to="/book-appointment">{t('common.bookAppointment')} →</Link>
                      <button type="button" onClick={closePanel}>
                        {t('common.close')}
                      </button>
                    </p>
                  </>
                ) : (
                  <p className="skeleton-callout-hint">{t('home.skeletonViewer.clickHint')}</p>
                )}
              </>
            )}
          </aside>

          <div className="skeleton-stage" ref={stageRef}>
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

          <div className="skeleton-joint-nav" role="list" aria-label={t('home.skeletonViewer.navLabel')}>
            {jointButtons.map((joint) => (
              <button
                key={joint.id}
                type="button"
                role="listitem"
                className={`skeleton-joint-chip ${selectedId === joint.id ? 'is-active' : ''}`}
                onClick={() => selectJoint(joint.id)}
              >
                {joint.label}
              </button>
            ))}
          </div>
        </div>

        <p className="skeleton-credit">{t('home.skeletonViewer.credit')}</p>
      </div>
    </section>
  )
}

export default SkeletonViewer
