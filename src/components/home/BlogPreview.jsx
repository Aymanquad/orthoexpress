import React from 'react'
import { Link } from 'react-router-dom'
import { getFeaturedBlogs } from '../../data'
import { useLanguage } from '../../context/LanguageContext'
import { getBlogField } from '../../data/blogs'
import { getBlogImage } from '../../data/images'
import ImageWithFallback from '../ImageWithFallback'
import './BlogPreview.css'

const BlogPreview = () => {
  const { t, lang } = useLanguage()
  const blogs = getFeaturedBlogs(3)

  return (
    <section className="blog-preview section">
      <div className="container">
        <div className="blog-header-section">
          <h2 className="section-title">{t('home.blogPreview.title')}</h2>
          <Link to="/blogs" className="all-blogs-link">{t('home.blogPreview.allBlogs')}</Link>
        </div>
        <div className="blog-grid">
          {blogs.map((blog) => {
            const blogImage = getBlogImage(blog.slug)
            return (
            <Link key={blog.slug} to={`/blogs/${blog.slug}`} className="blog-card">
              <div className="blog-image-wrapper">
                <ImageWithFallback
                  src={blogImage.src}
                  fallback={blogImage.fallback}
                  alt={getBlogField(blog, 'title', lang)}
                  className="blog-image"
                  loading="lazy"
                />
                <div className="blog-category-badge">{getBlogField(blog, 'category', lang)}</div>
              </div>
              <div className="blog-content">
                <div className="blog-meta-preview">
                  <span className="blog-category-preview">{getBlogField(blog, 'category', lang)}</span>
                  <span className="blog-date-preview">{getBlogField(blog, 'date', lang)}</span>
                </div>
                <h3 className="blog-title">{getBlogField(blog, 'title', lang)}</h3>
                <p className="blog-excerpt">{getBlogField(blog, 'excerpt', lang)}</p>
                <span className="blog-read-more">{t('home.blogPreview.readMore')}</span>
              </div>
            </Link>
            )
          })}
        </div>
      </div>
    </section>
  )
}

export default BlogPreview
