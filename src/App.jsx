import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import Header from './components/Header'
import Footer from './components/Footer'
import MobileActionBar from './components/MobileActionBar'
import ScrollToTop from './components/ScrollToTop'
import SkipToMain from './components/SkipToMain'
import ErrorBoundary from './components/ErrorBoundary'
import AccessibilityToolbar from './components/AccessibilityToolbar'
import Home from './pages/Home'
import About from './pages/About'
import WorkersComp from './pages/WorkersComp'
import Locations from './pages/Locations'
import LocationDetail from './pages/LocationDetail'
import Blogs from './pages/Blogs'
import BlogDetail from './pages/BlogDetail'
import ContactUs from './pages/ContactUs'
import BookAppointment from './pages/BookAppointment'
import Services from './pages/Services'
import ServiceDetail from './pages/ServiceDetail'
import Shop from './pages/Shop'
import Cart from './pages/Cart'
import Checkout from './pages/Checkout'
import OrderSuccess from './pages/OrderSuccess'
import OrderFailure from './pages/OrderFailure'
import Orders from './pages/Orders'
import Payment from './pages/Payment'
import FAQs from './pages/FAQs'
import Careers from './pages/Careers'
import News from './pages/News'
import Telehealth from './pages/Telehealth'
import AfterVisit from './pages/AfterVisit'
import PatientPortal from './pages/PatientPortal'
import Technology from './pages/Technology'
import AccessibilityStatement from './pages/AccessibilityStatement'
import PrivacyPolicy from './pages/PrivacyPolicy'
import TermsOfService from './pages/TermsOfService'
import NotFound from './pages/NotFound'
import './App.css'

function App() {
  return (
    <ErrorBoundary>
      <div className="App">
        <SkipToMain />
        <ScrollToTop />
        <Header />
        <main id="main-content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
            <Route path="/workers-comp" element={<WorkersComp />} />
            <Route path="/locations" element={<Locations />} />
            <Route path="/locations/:locationName" element={<LocationDetail />} />
            <Route path="/blogs" element={<Blogs />} />
            <Route path="/blogs/:slug" element={<BlogDetail />} />
            <Route path="/contact-us" element={<ContactUs />} />
            <Route path="/book-appointment" element={<BookAppointment />} />
            <Route path="/services" element={<Services />} />
            <Route
              path="/services/auto-injury"
              element={<Navigate to="/services/injuries-fractures-sprains" replace />}
            />
            <Route path="/services/:serviceName" element={<ServiceDetail />} />
            <Route path="/shop" element={<Shop />} />
            <Route path="/cart" element={<Cart />} />
            <Route path="/checkout" element={<Checkout />} />
            <Route path="/order-success/:orderId" element={<OrderSuccess />} />
            <Route path="/order-failure" element={<OrderFailure />} />
            <Route path="/orders" element={<Orders />} />
            <Route path="/payment" element={<Payment />} />
            <Route path="/faqs" element={<FAQs />} />
            <Route path="/telehealth" element={<Telehealth />} />
            <Route path="/after-your-visit" element={<AfterVisit />} />
            <Route path="/patient-portal" element={<PatientPortal />} />
            <Route path="/technology" element={<Technology />} />
            <Route path="/careers" element={<Careers />} />
            <Route path="/news" element={<News />} />
            <Route path="/accessibility" element={<AccessibilityStatement />} />
            <Route path="/privacy-policy" element={<PrivacyPolicy />} />
            <Route path="/terms" element={<TermsOfService />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </main>
        <Footer />
        <MobileActionBar />
        <AccessibilityToolbar />
      </div>
    </ErrorBoundary>
  )
}

export default App
