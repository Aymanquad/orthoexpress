import React from 'react'
import { Link } from 'react-router-dom'
import PageMeta from '../components/PageMeta'
import { NEWS_ITEMS } from '../data/content'
import { useLanguage } from '../context/LanguageContext'
import './InfoPages.css'

const News = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="info-page">
      <PageMeta
        title={t('pages.meta.news.title')}
        description={t('pages.meta.news.description')}
      />
      <section className="info-hero">
        <div className="container">
          <span className="info-eyebrow">{t('pages.info.newsEyebrow')}</span>
          <h1 className="page-title">{t('pages.info.newsTitle')}</h1>
          <p className="info-lead">{t('pages.info.newsLead')}</p>
        </div>
      </section>

      <section className="info-section">
        <div className="container">
          <div className="info-timeline">
            {NEWS_ITEMS.map((item) => (
              <article key={item.id} className="info-timeline-item">
                <div className="info-timeline-date">
                  {new Date(item.date).toLocaleDateString(lang === 'es' ? 'es-ES' : 'en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                  })}
                </div>
                <div className="info-timeline-body">
                  <span className="info-tag">{item.tag[lang] || item.tag.en}</span>
                  <h2>{item.title[lang] || item.title.en}</h2>
                  <p>{item.summary[lang] || item.summary.en}</p>
                </div>
              </article>
            ))}
          </div>

          <div className="info-actions">
            <Link to="/blogs" className="btn btn-primary">
              {t('pages.blogs.allBlogs')}
            </Link>
            <Link to="/contact-us" className="btn btn-outline">
              {t('common.contactUs')}
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default News
