import React from 'react'
import { Link } from 'react-router-dom'
import { FaPhone, FaEnvelope, FaMapMarkerAlt, FaClock, FaFacebook, FaLinkedin, FaInstagram } from 'react-icons/fa'
import { FaXTwitter, FaTiktok } from 'react-icons/fa6'
import { CLINIC } from '../data'
import { toTelLink } from '../data/utils'
import { useLanguage } from '../context/LanguageContext'
import './Footer.css'

const Footer = () => {
  const { headquarters, email, social } = CLINIC
  const { t } = useLanguage()

  const socialLinks = [
    { key: 'facebook', icon: FaFacebook, label: 'Facebook', url: social.facebook },
    { key: 'x', icon: FaXTwitter, label: 'X', url: social.x || social.twitter },
    { key: 'tiktok', icon: FaTiktok, label: 'TikTok', url: social.tiktok },
    { key: 'linkedin', icon: FaLinkedin, label: 'LinkedIn', url: social.linkedin },
    { key: 'instagram', icon: FaInstagram, label: 'Instagram', url: social.instagram },
  ].filter((item) => item.url)

  return (
    <footer className="footer">
      <div className="footer-container">
        <div className="footer-content">
          <div className="footer-section">
            <h3>{CLINIC.name}</h3>
            <p className="footer-tagline">{t('footer.tagline')}</p>
            <p>{t('footer.about')}</p>
            {socialLinks.length > 0 && (
              <div className="social-links">
                {socialLinks.map(({ key, icon: Icon, label, url }) => (
                  <a key={key} href={url} target="_blank" rel="noopener noreferrer" aria-label={label}>
                    <Icon />
                  </a>
                ))}
              </div>
            )}
          </div>

          <div className="footer-section">
            <h4>{t('footer.quickLinks')}</h4>
            <ul>
              <li><Link to="/">{t('nav.home')}</Link></li>
              <li><Link to="/about">{t('nav.about')}</Link></li>
              <li><Link to="/locations">{t('nav.locations')}</Link></li>
              <li><Link to="/shop">{t('nav.shop')}</Link></li>
              <li><Link to="/contact-us">{t('nav.contact')}</Link></li>
              <li><Link to="/book-appointment">{t('common.bookAppointment')}</Link></li>
            </ul>
          </div>

          <div className="footer-section">
            <h4>{t('footer.services')}</h4>
            <p className="footer-services-desc">{t('footer.viewAllServicesDesc')}</p>
            <Link to="/services" className="footer-services-cta">
              {t('footer.viewAllServices')}
            </Link>
            <ul className="footer-services-short">
              <li><Link to="/telehealth">{t('nav.telehealth')}</Link></li>
              <li><Link to="/payment">{t('nav.payment')}</Link></li>
              <li><Link to="/faqs">{t('nav.faqs')}</Link></li>
              <li><Link to="/blogs">{t('nav.blogs')}</Link></li>
            </ul>
          </div>

          <div className="footer-section">
            <h4>{t('footer.contactInfo')}</h4>
            <ul className="footer-contact-list">
              <li>
                <FaPhone aria-hidden="true" />
                <a href={toTelLink(headquarters.phone)}>{headquarters.phone}</a>
              </li>
              <li>
                <FaEnvelope aria-hidden="true" />
                <a href={`mailto:${email}`}>{email}</a>
              </li>
              <li>
                <FaMapMarkerAlt aria-hidden="true" />
                <Link to="/locations">
                  {headquarters.city} {t('pages.locations.andMore')}
                </Link>
              </li>
              <li>
                <FaClock aria-hidden="true" />
                <span>{t('pages.clinic.hoursWeekday')}</span>
              </li>
            </ul>
            <Link to="/book-appointment" className="btn-footer-appointment">
              {t('common.bookAppointment')}
            </Link>
          </div>
        </div>

        <div className="footer-bottom">
          <p>
            &copy; {new Date().getFullYear()} {CLINIC.name}. {t('footer.rights')}
          </p>
          <div className="footer-links">
            <Link to="/privacy-policy">{t('footer.privacy')}</Link>
            <span>|</span>
            <Link to="/terms">{t('footer.terms')}</Link>
            <span>|</span>
            <Link to="/accessibility">{t('footer.accessibility')}</Link>
            <span>|</span>
            <Link to="/admin/login">Staff / Admin</Link>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer
