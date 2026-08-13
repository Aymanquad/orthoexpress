import React, { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { FaSearch, FaTimes } from 'react-icons/fa'
import { ALL_SERVICE_LINKS, LOCATIONS, BLOGS, getServicePath, getBlogField } from '../data'
import { getServiceLabel } from '../data/services'
import { NEWS_ITEMS } from '../data/content'
import { useLanguage } from '../context/LanguageContext'
import './SiteSearch.css'

function buildIndex(lang, t) {
  const items = []

  ALL_SERVICE_LINKS.forEach((service) => {
    items.push({
      type: t('search.typeService'),
      title: getServiceLabel(service, lang),
      to: getServicePath(service),
    })
  })

  LOCATIONS.forEach((loc) => {
    items.push({
      type: t('search.typeLocation'),
      title: loc.name,
      to: `/locations/${loc.slug}`,
    })
  })

  BLOGS.forEach((blog) => {
    items.push({
      type: t('search.typeBlog'),
      title: getBlogField(blog, 'title', lang),
      to: `/blogs/${blog.slug}`,
    })
  })

  NEWS_ITEMS.forEach((news) => {
    items.push({
      type: t('search.typeNews'),
      title: news.title[lang] || news.title.en,
      to: '/news',
    })
  })

  items.push(
    { type: t('search.typePage'), title: t('nav.payment'), to: '/payment' },
    { type: t('search.typePage'), title: t('nav.telehealth'), to: '/telehealth' },
    { type: t('search.typePage'), title: t('nav.afterVisit'), to: '/after-your-visit' },
    { type: t('search.typePage'), title: t('nav.patientPortal'), to: '/patient-portal' },
    { type: t('search.typePage'), title: t('nav.technology'), to: '/technology' },
    { type: t('search.typePage'), title: t('nav.faqs'), to: '/faqs' },
    { type: t('search.typePage'), title: t('nav.careers'), to: '/careers' },
    { type: t('search.typePage'), title: t('nav.shop'), to: '/shop' },
    { type: t('search.typePage'), title: t('nav.contact'), to: '/contact-us' }
  )

  return items
}

const SiteSearch = () => {
  const { t, lang } = useLanguage()
  const [open, setOpen] = useState(false)
  const [query, setQuery] = useState('')
  const inputRef = useRef(null)
  const panelRef = useRef(null)

  const index = useMemo(() => buildIndex(lang, t), [lang, t])

  const results = useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return []
    return index.filter((item) => item.title.toLowerCase().includes(q)).slice(0, 8)
  }, [index, query])

  useEffect(() => {
    if (open && inputRef.current) inputRef.current.focus()
  }, [open])

  useEffect(() => {
    const onKey = (e) => {
      if (e.key === 'Escape') {
        setOpen(false)
        setQuery('')
      }
    }
    const onClick = (e) => {
      if (panelRef.current && !panelRef.current.contains(e.target)) {
        setOpen(false)
      }
    }
    document.addEventListener('keydown', onKey)
    document.addEventListener('mousedown', onClick)
    return () => {
      document.removeEventListener('keydown', onKey)
      document.removeEventListener('mousedown', onClick)
    }
  }, [])

  return (
    <div className="site-search" ref={panelRef}>
      <button
        type="button"
        className="site-search-trigger"
        aria-label={t('nav.search')}
        aria-expanded={open}
        onClick={() => setOpen((prev) => !prev)}
      >
        <FaSearch />
      </button>

      {open && (
        <div className="site-search-panel" role="dialog" aria-label={t('nav.search')}>
          <div className="site-search-input-row">
            <FaSearch aria-hidden="true" />
            <input
              ref={inputRef}
              type="search"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={t('nav.searchPlaceholder')}
              aria-label={t('nav.search')}
            />
            <button
              type="button"
              className="site-search-close"
              aria-label={t('common.close')}
              onClick={() => {
                setOpen(false)
                setQuery('')
              }}
            >
              <FaTimes />
            </button>
          </div>
          {query.trim() && (
            <ul className="site-search-results">
              {results.length === 0 && (
                <li className="site-search-empty">{t('common.noResults')}</li>
              )}
              {results.map((item) => (
                <li key={`${item.to}-${item.title}`}>
                  <Link
                    to={item.to}
                    onClick={() => {
                      setOpen(false)
                      setQuery('')
                    }}
                  >
                    <span className="site-search-type">{item.type}</span>
                    <span>{item.title}</span>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  )
}

export default SiteSearch
