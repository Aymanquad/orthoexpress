import React, { useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { useLanguage } from '../../context/LanguageContext'
import SkeletonViewer from '../../components/home/skeleton/SkeletonViewer'
import './AnatomyViewerEmbed.css'

/**
 * Chrome-free route for the native app's WebView (`/embed/anatomy-viewer`).
 *
 * The native shell already provides nav, cart and a language switcher, so this
 * renders the viewer alone and takes its language from `?lang=en|es`.
 */
const AnatomyViewerEmbed = () => {
  const [params] = useSearchParams()
  const { lang, setLang } = useLanguage()
  const requestedLang = params.get('lang') === 'es' ? 'es' : 'en'
  // `mode=stage` renders the 3D stage alone; the native app draws the rest.
  const stageOnly = params.get('mode') === 'stage'

  useEffect(() => {
    if (lang !== requestedLang) setLang(requestedLang)
  }, [lang, requestedLang, setLang])

  // Lets the host switch language without paying for a full page reload.
  useEffect(() => {
    window.OrthoEmbed = { ...(window.OrthoEmbed || {}), setLang }
    return () => {
      if (window.OrthoEmbed) delete window.OrthoEmbed.setLang
    }
  }, [setLang])

  return (
    <div className={`anatomy-embed ${stageOnly ? 'is-stage-only' : ''}`}>
      <SkeletonViewer embed stageOnly={stageOnly} />
    </div>
  )
}

export default AnatomyViewerEmbed
