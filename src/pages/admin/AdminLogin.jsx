import React, { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { FiCheckCircle, FiClipboard, FiShield } from 'react-icons/fi'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { isAdminUser, workplaceHome } from './workplacePaths'
import './Admin.css'

function safeFrom(from, user) {
  if (!from || from === '/admin/login') return workplaceHome(user)
  if (isAdminUser(user)) {
    return from.startsWith('/admin') ? from : workplaceHome(user)
  }
  if (from.startsWith('/staff/')) return from
  if (from.startsWith('/admin/') && from !== '/admin/staff') {
    const rest = from.replace(/^\/admin\//, '')
    return rest ? `${workplaceHome(user)}/${rest}` : workplaceHome(user)
  }
  return workplaceHome(user)
}

export default function AdminLogin() {
  const { login, isAuthenticated, loading, user } = useWorkplaceAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const from = location.state?.from

  const [email, setEmail] = useState('admin@orthoexpress.com')
  const [password, setPassword] = useState('admin123')
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  if (!loading && isAuthenticated) {
    return <Navigate to={safeFrom(from, user)} replace />
  }

  const onSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSubmitting(true)
    try {
      const nextUser = await login(email.trim(), password)
      navigate(safeFrom(from, nextUser), { replace: true })
    } catch (err) {
      setError(err.message || 'Invalid email or password')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="admin-login-page">
      <div className="admin-login-split">
        <aside className="admin-login-brand">
          <div>
            <p className="admin-kicker" style={{ color: '#86efac' }}>Practice portal</p>
            <h2>Care operations, in one place</h2>
            <p>Manage visits, orders, prescriptions, and patient records for OrthoExpress.</p>
            <ul>
              <li><FiCheckCircle /> Role-based staff access</li>
              <li><FiClipboard /> Prescriptions & demographics</li>
              <li><FiShield /> Separate from the patient portal</li>
            </ul>
          </div>
          <p>OrthoExpress clinic team</p>
        </aside>
        <form className="admin-login-card" onSubmit={onSubmit}>
          <h1>Sign in</h1>
          <p className="admin-muted">Use your workplace email. Admin and staff share this door.</p>
          <label>
            Email
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="username"
              required
            />
          </label>
          <label>
            Password
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="current-password"
              required
            />
          </label>
          {error ? <p className="admin-error">{error}</p> : null}
          <button type="submit" className="admin-primary-btn" disabled={submitting}>
            {submitting ? 'Signing in…' : 'Sign in'}
          </button>
          <p className="admin-hint">Demo admin: admin@orthoexpress.com / admin123</p>
          <Link to="/" className="admin-back-link">
            Back to site
          </Link>
        </form>
      </div>
    </div>
  )
}
