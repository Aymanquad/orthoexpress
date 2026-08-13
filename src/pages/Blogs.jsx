import React from 'react'
import { Link } from 'react-router-dom'
import { BLOGS } from '../data'
import { getBlogField } from '../data/blogs'
import { getBlogImage } from '../data/images'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import ImageWithFallback from '../components/ImageWithFallback'
import './Blogs.css'

const Blogs = () => {
  const { t, lang } = useLanguage()

  return (
    <div className="blogs-page">
      <PageMeta title={t('pages.meta.blogs.title')} description={t('pages.meta.blogs.description')} />

      <section className="blogs-hero section">
        <div className="container">
          <h1 className="page-title">{t('pages.blogs.title')}</h1>
          <p className="page-subtitle">{t('pages.blogs.subtitle')}</p>
        </div>
      </section>

      <section className="blogs-content section">
        <div className="container">
          <div className="blogs-grid">
            {BLOGS.map((blog) => {
              const blogImage = getBlogImage(blog.slug)
              return (
              <Link key={blog.slug} to={`/blogs/${blog.slug}`} className="blog-card-full">
                <div className="blog-image-wrapper-full">
                  <ImageWithFallback
                    src={blogImage.src}
                    fallback={blogImage.fallback}
                    alt={getBlogField(blog, 'title', lang)}
                    className="blog-image-full"
                    loading="lazy"
                  />
                  <span className="blog-category-overlay">{getBlogField(blog, 'category', lang)}</span>
                </div>
                <div className="blog-content-full">
                  <div className="blog-meta">
                    <span className="blog-category">{getBlogField(blog, 'category', lang)}</span>
                    <span className="blog-date">{getBlogField(blog, 'date', lang)}</span>
                  </div>
                  <h2 className="blog-title-full">{getBlogField(blog, 'title', lang)}</h2>
                  <p className="blog-excerpt-full">{getBlogField(blog, 'excerpt', lang)}</p>
                  <span className="blog-read-more-full">{t('pages.blogs.readMore')}</span>
                </div>
              </Link>
              )
            })}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Blogs
