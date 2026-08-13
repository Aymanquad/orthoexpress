import React from 'react'
import { useParams, Link } from 'react-router-dom'
import { getBlogBySlug } from '../data'
import { getBlogField } from '../data/blogs'
import { getBlogImage } from '../data/images'
import { useLanguage } from '../context/LanguageContext'
import PageMeta from '../components/PageMeta'
import PageHeroMedia from '../components/PageHeroMedia'
import PageBodyMedia from '../components/PageBodyMedia'
import NotFound from './NotFound'
import './BlogDetail.css'

const BlogDetail = () => {
  const { slug } = useParams()
  const { t, lang } = useLanguage()
  const blog = getBlogBySlug(slug)

  if (!blog) {
    return <NotFound />
  }

  const title = getBlogField(blog, 'title', lang)
  const excerpt = getBlogField(blog, 'excerpt', lang)
  const category = getBlogField(blog, 'category', lang)
  const blogImage = getBlogImage(blog.slug)
  const heroSrc = blogImage.heroSrc || (blogImage.placement === 'photo' ? blogImage.src : null)
  const bodySrc = blogImage.placement !== 'photo' ? blogImage.src : null

  return (
    <div className="blog-detail-page">
      <PageMeta title={title} description={excerpt} />

      <section className={`blog-detail-hero page-hero section${heroSrc ? '' : ' page-hero--no-media'}`}>
        {heroSrc && (
          <PageHeroMedia
            src={heroSrc}
            fallback={blogImage.fallback}
            alt={title}
            layout="photo"
          />
        )}
        <div className="container page-hero__content">
          <Link to="/blogs" className="back-link">
            {t('pages.blogs.backToBlogs')}
          </Link>
          <div className="blog-header">
            <span className="blog-category-badge">{category}</span>
            <h1 className="blog-detail-title">{title}</h1>
            <p className="blog-detail-date">{getBlogField(blog, 'date', lang)}</p>
          </div>
        </div>
      </section>

      <section className="blog-detail-content section">
        <div className="container">
          <div className="blog-article">
            {bodySrc && (
              <PageBodyMedia
                src={bodySrc}
                fallback={blogImage.fallback}
                alt={title}
                layout={blogImage.bodyLayout || 'square'}
              />
            )}
            <div className="blog-body" dangerouslySetInnerHTML={{ __html: getBlogField(blog, 'content', lang) }} />
            <div className="blog-detail-cta">
              <p>{t('shop.blogCta')}</p>
              <Link to="/book-appointment" className="btn btn-primary">
                {t('common.bookAppointment')}
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

export default BlogDetail
