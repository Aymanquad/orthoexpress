import React from 'react'
import { useParams, Link } from 'react-router-dom'
import './BlogDetail.css'

const BlogDetail = () => {
  const { slug } = useParams()

  // In a real app, you'd fetch this data based on the slug
  const blogData = {
    'understanding-orthopedic-injuries': {
      title: 'Understanding Common Orthopedic Injuries',
      date: 'March 15, 2024',
      category: 'General Health',
      image: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=1200&h=600&fit=crop',
      content: `
        <p>Orthopedic injuries are among the most common medical conditions affecting people of all ages. Understanding these injuries can help you recognize symptoms early and seek appropriate treatment.</p>
        
        <h3>Common Types of Orthopedic Injuries</h3>
        <p>Some of the most frequently encountered orthopedic injuries include:</p>
        <ul>
          <li><strong>Fractures:</strong> Broken bones that can occur from falls, accidents, or overuse.</li>
          <li><strong>Sprains and Strains:</strong> Injuries to ligaments (sprains) or muscles/tendons (strains).</li>
          <li><strong>Dislocations:</strong> When bones are forced out of their normal positions.</li>
          <li><strong>Tendinitis:</strong> Inflammation of tendons, often from repetitive motion.</li>
          <li><strong>Bursitis:</strong> Inflammation of the fluid-filled sacs that cushion joints.</li>
        </ul>

        <h3>Prevention Strategies</h3>
        <p>While not all injuries can be prevented, there are steps you can take to reduce your risk:</p>
        <ul>
          <li>Maintain a healthy weight to reduce stress on joints</li>
          <li>Engage in regular exercise to strengthen muscles and bones</li>
          <li>Use proper technique when lifting or performing physical activities</li>
          <li>Wear appropriate protective equipment during sports</li>
          <li>Take breaks during repetitive activities</li>
        </ul>

        <h3>When to Seek Medical Attention</h3>
        <p>If you experience severe pain, inability to move a joint, visible deformity, or symptoms that worsen over time, it's important to seek medical attention promptly. Early diagnosis and treatment can significantly improve outcomes.</p>
      `
    },
    'recovery-after-surgery': {
      title: 'Recovery Tips After Orthopedic Surgery',
      date: 'March 10, 2024',
      category: 'Recovery',
      image: '/assets/recovery-after-orthopedicsurgery.jpg',
      content: `
        <p>Recovery after orthopedic surgery requires patience, dedication, and following your doctor's instructions carefully. Here are essential tips to help you through the recovery process.</p>
        
        <h3>Follow Your Doctor's Instructions</h3>
        <p>Your surgeon will provide specific instructions based on your procedure. It's crucial to follow these guidelines regarding activity levels, medications, and wound care.</p>

        <h3>Manage Pain Effectively</h3>
        <p>Pain management is crucial for recovery. Take prescribed medications as directed and communicate with your healthcare team about your pain levels.</p>

        <h3>Physical Therapy</h3>
        <p>Most orthopedic surgeries require physical therapy to restore function. Attend all sessions and perform home exercises as recommended.</p>

        <h3>Nutrition and Hydration</h3>
        <p>Proper nutrition supports healing. Focus on protein-rich foods, vitamins, and stay well-hydrated.</p>

        <h3>Rest and Activity Balance</h3>
        <p>Balance rest with appropriate activity. Too much rest can delay recovery, while too much activity can cause complications.</p>
      `
    },
    'sports-injury-prevention': {
      title: 'Sports Injury Prevention Strategies',
      date: 'March 5, 2024',
      category: 'Sports Medicine',
      image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=1200&h=600&fit=crop',
      content: `
        <p>Preventing sports injuries is essential for athletes of all levels. Here are proven strategies to keep you in the game.</p>
        
        <h3>Proper Warm-up and Cool-down</h3>
        <p>Always warm up before activity and cool down afterward. This prepares your body for exercise and helps with recovery.</p>

        <h3>Use Proper Equipment</h3>
        <p>Wear appropriate protective gear and ensure equipment fits correctly. This includes helmets, pads, and proper footwear.</p>

        <h3>Gradual Progression</h3>
        <p>Avoid sudden increases in training intensity or duration. Gradually build up your activity level to prevent overuse injuries.</p>

        <h3>Cross-Training</h3>
        <p>Engage in a variety of activities to prevent overuse of specific muscle groups and maintain overall fitness.</p>

        <h3>Listen to Your Body</h3>
        <p>Pay attention to pain and fatigue. Rest when needed and don't push through injuries.</p>
      `
    },
    'managing-chronic-pain': {
      title: 'Managing Chronic Orthopedic Pain',
      date: 'February 28, 2024',
      category: 'Pain Management',
      image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=1200&h=600&fit=crop',
      content: `
        <p>Chronic orthopedic pain can significantly impact your daily life and well-being. Here are effective strategies for managing long-term pain and improving your quality of life.</p>
        
        <h3>Understanding Chronic Pain</h3>
        <p>Chronic pain persists beyond the normal healing period and may require ongoing management strategies. Understanding your pain is the first step toward effective treatment.</p>

        <h3>Medical Treatment Options</h3>
        <p>Various medical treatments can help manage chronic pain, including medications, injections, and physical therapy. Work with your healthcare provider to find the right combination.</p>

        <h3>Lifestyle Modifications</h3>
        <p>Simple lifestyle changes can make a significant difference. This includes maintaining a healthy weight, staying active within your limits, and practicing stress management techniques.</p>

        <h3>Mind-Body Techniques</h3>
        <p>Techniques such as meditation, deep breathing, and mindfulness can help you better manage pain and reduce its impact on your life.</p>
      `
    },
    'exercise-for-joint-health': {
      title: 'Exercise for Joint Health',
      date: 'February 20, 2024',
      category: 'Exercise',
      image: '/assets/joint-img.jpg',
      content: `
        <p>Regular exercise is essential for maintaining healthy joints and preventing orthopedic issues. Discover the best exercises to keep your joints strong and flexible.</p>
        
        <h3>Low-Impact Exercises</h3>
        <p>Low-impact activities like swimming, cycling, and walking are excellent for joint health. These exercises strengthen muscles without excessive stress on joints.</p>

        <h3>Strength Training</h3>
        <p>Building muscle strength supports and protects your joints. Focus on exercises that target the muscles around your joints without causing pain.</p>

        <h3>Flexibility and Range of Motion</h3>
        <p>Stretching and range-of-motion exercises help maintain joint flexibility and prevent stiffness. Regular stretching can improve mobility and reduce the risk of injury.</p>

        <h3>Balance and Stability</h3>
        <p>Balance exercises help prevent falls and injuries. Simple balance training can significantly improve joint stability and coordination.</p>
      `
    },
    'when-to-see-orthopedic-specialist': {
      title: 'When to See an Orthopedic Specialist',
      date: 'February 15, 2024',
      category: 'General Health',
      image: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=1200&h=600&fit=crop',
      content: `
        <p>Knowing when to see an orthopedic specialist can help you get the right care at the right time. Here are key signs and symptoms that indicate you should consult with an orthopedic specialist.</p>
        
        <h3>Persistent Pain</h3>
        <p>If you experience pain that lasts more than a few weeks or interferes with your daily activities, it's time to see a specialist. Persistent pain may indicate an underlying condition that needs professional evaluation.</p>

        <h3>Limited Range of Motion</h3>
        <p>Difficulty moving a joint through its full range of motion, or feeling that a joint is stuck, warrants a specialist consultation. This could indicate injury or joint degeneration.</p>

        <h3>Joint Instability</h3>
        <p>If a joint feels weak, gives way, or feels like it might "pop out," you should see an orthopedic specialist. Instability can lead to further injury if not addressed.</p>

        <h3>Visible Deformity or Swelling</h3>
        <p>Visible changes in joint appearance, significant swelling, or deformity require immediate medical attention. These symptoms may indicate serious injury or infection.</p>
      `
    }
  }

  const blog = blogData[slug] || {
    title: 'Blog Post',
    date: 'Date',
    category: 'Category',
    image: '',
    content: '<p>Content not found.</p>'
  }

  return (
    <div className="blog-detail-page">
      <section className="blog-detail-hero section">
        {blog.image && (
          <div className="blog-detail-hero-background">
            <img 
              src={blog.image} 
              alt={blog.title}
              className="blog-detail-hero-image"
            />
            <div className="blog-detail-hero-overlay"></div>
          </div>
        )}
        <div className="container">
          <Link to="/blogs" className="back-link">← Back to Blogs</Link>
          <div className="blog-header">
            <span className="blog-category-badge">{blog.category}</span>
            <h1 className="blog-detail-title">{blog.title}</h1>
            <p className="blog-detail-date">{blog.date}</p>
          </div>
        </div>
      </section>

      <section className="blog-detail-content section">
        <div className="container">
          <div className="blog-article">
            <div 
              className="blog-body"
              dangerouslySetInnerHTML={{ __html: blog.content }}
            />
          </div>
        </div>
      </section>
    </div>
  )
}

export default BlogDetail

