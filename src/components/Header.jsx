import React, { useEffect, useRef, useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import {
  FaPhone,
  FaBars,
  FaTimes,
  FaShoppingCart,
  FaChevronDown,
  FaArrowRight,
  FaIdCard,
  FaDollarSign,
  FaVideo,
  FaClipboardList,
  FaUserCircle,
  FaLaptop,
  FaStore,
  FaBoxOpen,
  FaMapMarkerAlt,
  FaNewspaper,
  FaQuestionCircle,
  FaBriefcase,
  FaCalendarAlt,
} from 'react-icons/fa'
import { CLINIC, getLocationNavItems } from '../data'
import {
  NAV_SERVICES,
  SPECIALTY_SERVICES,
  WORKERS_COMP_SERVICE,
  getServicePath,
  getServiceLabel,
} from '../data/services'
import { useCart } from '../context/CartContext'
import { useLanguage } from '../context/LanguageContext'
import { useAuth } from '../context/AuthContext'
import { toTelLink } from '../data/utils'
import SiteSearch from './SiteSearch'
import LanguageToggle from './LanguageToggle'
import './Header.css'

const DROPDOWN_CLOSE_DELAY = 250

const Header = () => {
  const { pathname } = useLocation()
  const { cartCount } = useCart()
  const { t, lang } = useLanguage()
  const { isAuthenticated } = useAuth()
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [openDropdown, setOpenDropdown] = useState(null)
  const closeTimerRef = useRef(null)
  const navRef = useRef(null)

  const locations = getLocationNavItems()
  const isShopActive =
    pathname.startsWith('/shop') ||
    pathname.startsWith('/cart') ||
    pathname.startsWith('/checkout') ||
    pathname.startsWith('/orders') ||
    pathname.startsWith('/order-success')
  const isPatientsActive =
    pathname.startsWith('/telehealth') ||
    pathname.startsWith('/after-your-visit') ||
    pathname.startsWith('/patient-portal') ||
    pathname.startsWith('/portal') ||
    pathname.startsWith('/technology') ||
    pathname.startsWith('/payment') ||
    pathname.startsWith('/faqs') ||
    pathname.startsWith('/blogs') ||
    pathname.startsWith('/news') ||
    pathname.startsWith('/careers')
  const { headquarters } = CLINIC

  const isActive = (path, { exact = false, prefix = false } = {}) => {
    if (exact) return pathname === path
    if (prefix) return pathname.startsWith(path)
    return pathname === path
  }

  const navClass = (path, options) => (isActive(path, options) ? 'nav-link-active' : '')

  const clearCloseTimer = () => {
    if (closeTimerRef.current) {
      clearTimeout(closeTimerRef.current)
      closeTimerRef.current = null
    }
  }

  const openDropdownMenu = (name) => {
    clearCloseTimer()
    setOpenDropdown(name)
  }

  const scheduleCloseDropdown = () => {
    clearCloseTimer()
    closeTimerRef.current = setTimeout(() => {
      setOpenDropdown(null)
    }, DROPDOWN_CLOSE_DELAY)
  }

  const closeAllDropdowns = () => {
    clearCloseTimer()
    setOpenDropdown(null)
  }

  const toggleMenu = () => {
    setIsMenuOpen((prev) => {
      if (prev) closeAllDropdowns()
      return !prev
    })
  }

  const handleDropdownTriggerClick = (name) => (e) => {
    e.preventDefault()
    e.stopPropagation()
    clearCloseTimer()
    setOpenDropdown((prev) => (prev === name ? null : name))
  }

  const closeMenu = () => {
    setIsMenuOpen(false)
    closeAllDropdowns()
  }

  const isServiceLinkActive = (service) => {
    const path = getServicePath(service)
    if (path === '/services') return pathname === '/services'
    return pathname === path
  }

  useEffect(() => {
    closeAllDropdowns()
    setIsMenuOpen(false)
  }, [pathname])

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (navRef.current && !navRef.current.contains(event.target)) {
        closeAllDropdowns()
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  useEffect(() => () => clearCloseTimer(), [])

  const isServicesOpen = openDropdown === 'services'
  const isLocationsOpen = openDropdown === 'locations'
  const isShopOpen = openDropdown === 'shop'
  const isPatientsOpen = openDropdown === 'patients'

  return (
    <header className="header">
      <div className="header-top-bar">
        <div className="header-top-container">
          <div className="header-top-left">
            <Link to="/" className="logo-top">
              <span className="logo-text">{CLINIC.name}</span>
            </Link>
            <span className="top-tagline">{t('pages.clinic.tagline')}</span>
          </div>
          <div className="header-top-right">
            <div className="top-location">
              <FaPhone className="phone-icon-top" aria-hidden="true" />
              <div>
                <span className="location-name-top">{headquarters.label}</span>
                <div className="phone-info">
                  <a href={toTelLink(headquarters.phone)}>{headquarters.phone}</a>
                </div>
              </div>
            </div>
            <Link to="/book-appointment" className="btn-book-top">
              {t('nav.bookAppointment')}
            </Link>
            {isAuthenticated ? (
              <Link to="/portal" className="portal-header-portal">
                {t('portal.myPortal')}
              </Link>
            ) : (
              <Link to="/portal/login" className="portal-header-signin">
                {t('portal.signIn')}
              </Link>
            )}
            <LanguageToggle />
          </div>
        </div>
      </div>

      <div className="header-container">
        <nav ref={navRef} className={`nav ${isMenuOpen ? 'nav-open' : ''}`} aria-label={t('a11y.mainNav')}>
          <button
            className="menu-toggle"
            onClick={toggleMenu}
            aria-label={isMenuOpen ? t('pages.header.closeMenu') : t('pages.header.openMenu')}
          >
            {isMenuOpen ? <FaTimes /> : <FaBars />}
          </button>

          <ul className="nav-menu">
            <li>
              <Link to="/" className={navClass('/', { exact: true })} onClick={closeMenu}>
                {t('nav.home')}
              </Link>
            </li>

            <li
              className={`nav-item-dropdown${isServicesOpen ? ' is-open' : ''}`}
              onMouseEnter={() => openDropdownMenu('services')}
              onMouseLeave={scheduleCloseDropdown}
            >
              <span
                className={navClass('/services', { prefix: true })}
                onClick={handleDropdownTriggerClick('services')}
                onKeyDown={(e) => e.key === 'Enter' && handleDropdownTriggerClick('services')(e)}
                role="button"
                tabIndex={0}
                aria-expanded={isServicesOpen}
                aria-haspopup="true"
              >
                {t('nav.services')}
                <FaChevronDown className="nav-caret" aria-hidden="true" />
              </span>
              {isServicesOpen && (
                <div
                  className="dropdown-menu dropdown-mega"
                  onMouseEnter={() => openDropdownMenu('services')}
                  onMouseLeave={scheduleCloseDropdown}
                >
                  <Link
                    to="/services"
                    className={`dropdown-featured${pathname === '/services' ? ' nav-link-active' : ''}`}
                    onClick={closeMenu}
                  >
                    <span>{t('nav.allServices')}</span>
                    <FaArrowRight aria-hidden="true" />
                  </Link>
                  <div className="dropdown-mega-grid">
                    <div className="dropdown-col">
                      <p className="dropdown-label">{t('nav.coreCare')}</p>
                      <ul>
                        {NAV_SERVICES.map((service) => (
                          <li key={service.slug}>
                            <Link
                              to={getServicePath(service)}
                              className={isServiceLinkActive(service) ? 'nav-link-active' : ''}
                              onClick={closeMenu}
                            >
                              {getServiceLabel(service, lang)}
                            </Link>
                          </li>
                        ))}
                      </ul>
                    </div>
                    <div className="dropdown-col">
                      <p className="dropdown-label">{t('nav.specialtyCare')}</p>
                      <ul>
                        {SPECIALTY_SERVICES.map((service) => (
                          <li key={service.slug}>
                            <Link
                              to={getServicePath(service)}
                              className={isServiceLinkActive(service) ? 'nav-link-active' : ''}
                              onClick={closeMenu}
                            >
                              {getServiceLabel(service, lang)}
                            </Link>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                  <Link
                    to="/workers-comp"
                    className={`dropdown-footer-link${pathname === '/workers-comp' ? ' nav-link-active' : ''}`}
                    onClick={closeMenu}
                  >
                    {getServiceLabel(WORKERS_COMP_SERVICE, lang)}
                  </Link>
                </div>
              )}
            </li>

            <li
              className={`nav-item-dropdown${isPatientsOpen ? ' is-open' : ''}`}
              onMouseEnter={() => openDropdownMenu('patients')}
              onMouseLeave={scheduleCloseDropdown}
            >
              <span
                className={isPatientsActive ? 'nav-link-active' : ''}
                onClick={handleDropdownTriggerClick('patients')}
                onKeyDown={(e) => e.key === 'Enter' && handleDropdownTriggerClick('patients')(e)}
                role="button"
                tabIndex={0}
                aria-expanded={isPatientsOpen}
                aria-haspopup="true"
              >
                {t('nav.patients')}
                <FaChevronDown className="nav-caret" aria-hidden="true" />
              </span>
              {isPatientsOpen && (
                <div
                  className="dropdown-menu dropdown-patients"
                  onMouseEnter={() => openDropdownMenu('patients')}
                  onMouseLeave={scheduleCloseDropdown}
                >
                  <div className="dropdown-mega-grid">
                    <div className="dropdown-col">
                      <p className="dropdown-label">{t('nav.yourCare')}</p>
                      <ul>
                        <li>
                          <Link
                            to="/telehealth"
                            className={pathname === '/telehealth' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaVideo className="dropdown-ico" aria-hidden="true" />
                            {t('nav.telehealth')}
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/after-your-visit"
                            className={pathname === '/after-your-visit' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaClipboardList className="dropdown-ico" aria-hidden="true" />
                            {t('nav.afterVisit')}
                          </Link>
                        </li>
                        {isAuthenticated && (
                          <li>
                            <Link
                              to="/portal/appointments"
                              className={pathname === '/portal/appointments' ? 'nav-link-active' : ''}
                              onClick={closeMenu}
                            >
                              <FaCalendarAlt className="dropdown-ico" aria-hidden="true" />
                              {t('portal.myAppointments')}
                            </Link>
                          </li>
                        )}
                        <li>
                          <Link
                            to="/patient-portal"
                            className={pathname === '/patient-portal' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaUserCircle className="dropdown-ico" aria-hidden="true" />
                            {t('nav.patientPortal')}
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/technology"
                            className={pathname === '/technology' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaLaptop className="dropdown-ico" aria-hidden="true" />
                            {t('nav.technology')}
                          </Link>
                        </li>
                      </ul>
                    </div>
                    <div className="dropdown-col">
                      <p className="dropdown-label">{t('nav.billingHelp')}</p>
                      <ul>
                        <li>
                          <Link
                            to="/payment#insurance"
                            className={pathname === '/payment' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaIdCard className="dropdown-ico" aria-hidden="true" />
                            {t('nav.insuranceProviders')}
                          </Link>
                        </li>
                        <li>
                          <Link to="/payment#self-pay" onClick={closeMenu}>
                            <FaDollarSign className="dropdown-ico" aria-hidden="true" />
                            {t('nav.selfPay')}
                          </Link>
                        </li>
                      </ul>
                      <p className="dropdown-label">{t('nav.resources')}</p>
                      <ul>
                        <li>
                          <Link
                            to="/faqs"
                            className={pathname === '/faqs' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaQuestionCircle className="dropdown-ico" aria-hidden="true" />
                            {t('nav.faqs')}
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/blogs"
                            className={pathname.startsWith('/blogs') ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaNewspaper className="dropdown-ico" aria-hidden="true" />
                            {t('nav.blogs')}
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/news"
                            className={pathname === '/news' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaNewspaper className="dropdown-ico" aria-hidden="true" />
                            {t('nav.news')}
                          </Link>
                        </li>
                        <li>
                          <Link
                            to="/careers"
                            className={pathname === '/careers' ? 'nav-link-active' : ''}
                            onClick={closeMenu}
                          >
                            <FaBriefcase className="dropdown-ico" aria-hidden="true" />
                            {t('nav.careers')}
                          </Link>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              )}
            </li>

            <li>
              <Link to="/about" className={navClass('/about')} onClick={closeMenu}>
                {t('nav.about')}
              </Link>
            </li>

            <li
              className={`nav-item-dropdown${isLocationsOpen ? ' is-open' : ''}`}
              onMouseEnter={() => openDropdownMenu('locations')}
              onMouseLeave={scheduleCloseDropdown}
            >
              <span
                className={navClass('/locations', { prefix: true })}
                onClick={handleDropdownTriggerClick('locations')}
                onKeyDown={(e) => e.key === 'Enter' && handleDropdownTriggerClick('locations')(e)}
                role="button"
                tabIndex={0}
                aria-expanded={isLocationsOpen}
                aria-haspopup="true"
              >
                {t('nav.locations')}
                <FaChevronDown className="nav-caret" aria-hidden="true" />
              </span>
              {isLocationsOpen && (
                <ul
                  className="dropdown-menu dropdown-menu-compact"
                  onMouseEnter={() => openDropdownMenu('locations')}
                  onMouseLeave={scheduleCloseDropdown}
                >
                  <li>
                    <Link
                      to="/locations"
                      className={pathname === '/locations' ? 'nav-link-active' : ''}
                      onClick={closeMenu}
                    >
                      <FaMapMarkerAlt className="dropdown-ico" aria-hidden="true" />
                      {t('nav.findCenter')}
                    </Link>
                  </li>
                  {locations.map((location) => (
                    <li key={location.slug}>
                      <Link
                        to={`/locations/${location.slug}`}
                        className={pathname === `/locations/${location.slug}` ? 'nav-link-active' : ''}
                        onClick={closeMenu}
                      >
                        <FaMapMarkerAlt className="dropdown-ico" aria-hidden="true" />
                        {location.name}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </li>

            <li
              className={`nav-item-dropdown${isShopOpen ? ' is-open' : ''}`}
              onMouseEnter={() => openDropdownMenu('shop')}
              onMouseLeave={scheduleCloseDropdown}
            >
              <span
                className={isShopActive ? 'nav-link-active' : ''}
                onClick={handleDropdownTriggerClick('shop')}
                onKeyDown={(e) => e.key === 'Enter' && handleDropdownTriggerClick('shop')(e)}
                role="button"
                tabIndex={0}
                aria-expanded={isShopOpen}
                aria-haspopup="true"
              >
                {t('nav.shop')}
                <FaChevronDown className="nav-caret" aria-hidden="true" />
              </span>
              {isShopOpen && (
                <ul
                  className="dropdown-menu dropdown-menu-compact"
                  onMouseEnter={() => openDropdownMenu('shop')}
                  onMouseLeave={scheduleCloseDropdown}
                >
                  <li>
                    <Link
                      to="/shop"
                      className={pathname === '/shop' ? 'nav-link-active' : ''}
                      onClick={closeMenu}
                    >
                      <FaStore className="dropdown-ico" aria-hidden="true" />
                      {t('nav.orthoShop')}
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/orders"
                      className={
                        pathname === '/orders' || pathname.startsWith('/order-success')
                          ? 'nav-link-active'
                          : ''
                      }
                      onClick={closeMenu}
                    >
                      <FaBoxOpen className="dropdown-ico" aria-hidden="true" />
                      {t('nav.orders')}
                    </Link>
                  </li>
                  <li>
                    <Link
                      to="/cart"
                      className={pathname === '/cart' ? 'nav-link-active' : ''}
                      onClick={closeMenu}
                    >
                      <FaShoppingCart className="dropdown-ico" aria-hidden="true" />
                      {t('nav.cart')}
                      {cartCount > 0 ? ` (${cartCount})` : ''}
                    </Link>
                  </li>
                </ul>
              )}
            </li>

            <li>
              <Link to="/contact-us" className={navClass('/contact-us')} onClick={closeMenu}>
                {t('nav.contact')}
              </Link>
            </li>

            <li className="nav-utils-item">
              <SiteSearch />
            </li>
            <li className="nav-cart-icon-item">
              <Link
                to="/cart"
                className="nav-cart-link"
                onClick={closeMenu}
                aria-label={`${t('nav.cart')} (${cartCount})`}
              >
                <FaShoppingCart />
                {cartCount > 0 && <span className="nav-cart-badge">{cartCount}</span>}
              </Link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  )
}

export default Header
