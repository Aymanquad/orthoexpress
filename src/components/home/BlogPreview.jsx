import React from 'react'
import { Link } from 'react-router-dom'
import './BlogPreview.css'

const BlogPreview = () => {
  const blogs = [
    {
      slug: 'understanding-orthopedic-injuries',
      title: 'Understanding Common Orthopedic Injuries',
      excerpt: 'Learn about the most common orthopedic injuries and how to prevent them in your daily life.',
      date: 'March 15, 2024',
      category: 'General Health',
      image: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=800&h=600&fit=crop'
    },
    {
      slug: 'recovery-after-surgery',
      title: 'Recovery Tips After Orthopedic Surgery',
      excerpt: 'Essential tips and guidelines for a smooth recovery process after orthopedic procedures.',
      date: 'March 10, 2024',
      category: 'Recovery',
      image: '/assets/recovery-after-orthopedicsurgery.jpg'
    },
    {
      slug: 'sports-injury-prevention',
      title: 'Sports Injury Prevention Strategies',
      excerpt: 'Expert advice on preventing sports-related injuries and maintaining peak performance.',
      date: 'March 5, 2024',
      category: 'Sports Medicine',
      image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&h=600&fit=crop'
    }
  ]

  return (
    <section className="blog-preview section">
      <div className="container">
        <div className="blog-header-section">
          <h2 className="section-title">Our Blogs</h2>
          <Link to="/blogs" className="all-blogs-link">All Blogs →</Link>
        </div>
        <div className="blog-grid">
          {blogs.map((blog) => (
            <Link 
              key={blog.slug} 
              to={`/blogs/${blog.slug}`}
              className="blog-card"
            >
              <div className="blog-image-wrapper">
                <img 
                  src={blog.image} 
                  alt={blog.title}
                  className="blog-image"
                  loading="lazy"
                  onError={(e) => {
                    e.target.src = 'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800&h=600&fit=crop'
                  }}
                />
                <div className="blog-category-badge">{blog.category}</div>
              </div>
              <div className="blog-content">
                <div className="blog-meta-preview">
                  <span className="blog-category-preview">{blog.category}</span>
                  <span className="blog-date-preview">{blog.date}</span>
                </div>
                <h3 className="blog-title">{blog.title}</h3>
                <p className="blog-excerpt">{blog.excerpt}</p>
                <span className="blog-read-more">Read More →</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  )
}

export default BlogPreview

