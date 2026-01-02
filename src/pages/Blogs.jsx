import React from 'react'
import { Link } from 'react-router-dom'
import './Blogs.css'

const Blogs = () => {
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
    },
    {
      slug: 'managing-chronic-pain',
      title: 'Managing Chronic Orthopedic Pain',
      excerpt: 'Effective strategies for managing long-term orthopedic pain and improving quality of life.',
      date: 'February 28, 2024',
      category: 'Pain Management',
      image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&h=600&fit=crop'
    },
    {
      slug: 'exercise-for-joint-health',
      title: 'Exercise for Joint Health',
      excerpt: 'Discover the best exercises to maintain healthy joints and prevent orthopedic issues.',
      date: 'February 20, 2024',
      category: 'Exercise',
      image: '/assets/joint-img.jpg'
    },
    {
      slug: 'when-to-see-orthopedic-specialist',
      title: 'When to See an Orthopedic Specialist',
      excerpt: 'Learn the signs and symptoms that indicate you should consult with an orthopedic specialist.',
      date: 'February 15, 2024',
      category: 'General Health',
      image: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800&h=600&fit=crop'
    }
  ]

  return (
    <div className="blogs-page">
      <section className="blogs-hero section">
        <div className="container">
          <h1 className="page-title">Our Blog</h1>
          <p className="page-subtitle">Orthopedic Health Tips and Insights</p>
        </div>
      </section>

      <section className="blogs-content section">
        <div className="container">
          <div className="blogs-grid">
            {blogs.map((blog) => (
              <Link 
                key={blog.slug} 
                to={`/blogs/${blog.slug}`}
                className="blog-card-full"
              >
                <div className="blog-image-wrapper-full">
                  <img 
                    src={blog.image} 
                    alt={blog.title}
                    className="blog-image-full"
                    loading="lazy"
                  />
                  <div className="blog-category-overlay">{blog.category}</div>
                </div>
                <div className="blog-content-full">
                  <div className="blog-meta">
                    <span className="blog-category">{blog.category}</span>
                    <span className="blog-date">{blog.date}</span>
                  </div>
                  <h2 className="blog-title-full">{blog.title}</h2>
                  <p className="blog-excerpt-full">{blog.excerpt}</p>
                  <span className="blog-read-more-full">Read More →</span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </section>
    </div>
  )
}

export default Blogs

