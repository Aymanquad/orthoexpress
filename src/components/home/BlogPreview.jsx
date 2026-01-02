import React from 'react'
import { Link } from 'react-router-dom'
import './BlogPreview.css'

const BlogPreview = () => {
  const featuredBlogs = [
    {
      slug: 'sprained-ankle-treatment',
      title: 'Sprained Ankle: Understanding and Treating This Common Injury',
      excerpt: 'A sprained ankle is a common injury that occurs when the ligaments...',
      category: 'Top Orthopedic Surgeon',
      location: 'Top-Orthopedic surgeon in Lancaster | Sprained ankle treatment'
    },
    {
      slug: 'wrist-pain-orthopedics',
      title: 'Wrist Pain Woes? Find Relief with an Orthopedic Specialist',
      excerpt: 'Wrist pain is a common complaint that can arise from a...',
      category: 'Wrist Pain Orthopedics',
      location: 'Wrist pain | Orthopedics in Farmers Branch, TX'
    },
    {
      slug: 'turf-toe-treatment',
      title: 'Conquering Turf Toe: Effective Orthopedic Care for Foot and Ankle Health',
      excerpt: 'Our feet and ankles are the foundation of our...',
      category: 'Foot and Ankle Health',
      location: 'Turf toe got you down? See an ortho doc'
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
          {featuredBlogs.map((blog, index) => {
            const blogImages = [
              'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800&h=600&fit=crop',
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&h=600&fit=crop',
              'https://images.unsplash.com/photo-1582719471384-894fbb16e074?w=800&h=600&fit=crop'
            ]
            return (
              <Link 
                key={blog.slug} 
                to={`/blogs/${blog.slug}`}
                className="blog-card"
              >
                <div className="blog-image-wrapper">
                  <img 
                    src={blogImages[index]} 
                    alt={blog.title}
                    className="blog-image"
                    loading="lazy"
                    onError={(e) => {
                      e.target.src = 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=800&h=600&fit=crop'
                    }}
                  />
                  <div className="blog-category-badge">{blog.category}</div>
                </div>
                <div className="blog-content">
                  <p className="blog-location">{blog.location}</p>
                  <h3 className="blog-title">{blog.title}</h3>
                  <p className="blog-excerpt">{blog.excerpt}</p>
                  <span className="blog-read-more">Read More →</span>
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

