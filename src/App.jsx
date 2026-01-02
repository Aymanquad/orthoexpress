import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Header from './components/Header'
import Footer from './components/Footer'
import Home from './pages/Home'
import About from './pages/About'
import WorkersComp from './pages/WorkersComp'
import Locations from './pages/Locations'
import Blogs from './pages/Blogs'
import BlogDetail from './pages/BlogDetail'
import ContactUs from './pages/ContactUs'
import BookAppointment from './pages/BookAppointment'
import ServiceDetail from './pages/ServiceDetail'
import './App.css'

function App() {
  return (
    <div className="App">
      <Header />
      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/workers-comp" element={<WorkersComp />} />
          <Route path="/locations" element={<Locations />} />
          <Route path="/blogs" element={<Blogs />} />
          <Route path="/blogs/:slug" element={<BlogDetail />} />
          <Route path="/contact-us" element={<ContactUs />} />
          <Route path="/book-appointment" element={<BookAppointment />} />
          <Route path="/services/:serviceName" element={<ServiceDetail />} />
        </Routes>
      </main>
      <Footer />
    </div>
  )
}

export default App

