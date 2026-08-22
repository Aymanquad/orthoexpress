import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { workplaceHome } from './workplacePaths'
import { AdminAvatar, RoleBadge } from './adminUi'
import './Admin.css'

export default function AdminProfile() {
  const { user, isAdmin, updateProfile } = useWorkplaceAuth()
  const navigate = useNavigate()
  const [form, setForm] = useState({
    firstName: '',
    lastName: '',
    phone: '',
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  })
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  useEffect(() => {
    if (!user) return
    setForm((f) => ({
      ...f,
      firstName: user.firstName || '',
      lastName: user.lastName || '',
      phone: user.phone || '',
    }))
  }, [user])

  const onSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    if (form.newPassword || form.confirmPassword || form.currentPassword) {
      if (!form.currentPassword) {
        setError('Enter your current password to change it.')
        return
      }
      if (form.newPassword.length < 6) {
        setError('New password must be at least 6 characters.')
        return
      }
      if (form.newPassword !== form.confirmPassword) {
        setError('New password and confirmation do not match.')
        return
      }
    }

    setSaving(true)
    try {
      const payload = {
        firstName: form.firstName.trim(),
        lastName: form.lastName.trim(),
        phone: form.phone.trim() || null,
      }
      if (form.newPassword) {
        payload.currentPassword = form.currentPassword
        payload.newPassword = form.newPassword
      }
      const next = await updateProfile(payload)
      setForm((f) => ({
        ...f,
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      }))
      setSuccess('Profile saved.')
      // Staff name changes update the URL slug.
      if (!isAdmin) {
        navigate(workplaceHome(next) + '/profile', { replace: true })
      }
    } catch (err) {
      setError(err.message || 'Could not save profile')
    } finally {
      setSaving(false)
    }
  }

  const name =
    [user?.firstName, user?.lastName].filter(Boolean).join(' ') || user?.email || 'Account'
  const pwMismatch = form.confirmPassword && form.newPassword !== form.confirmPassword
  const pwShort = form.newPassword && form.newPassword.length > 0 && form.newPassword.length < 6

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Account</p>
          <h1>Profile</h1>
          <p className="admin-muted">Update how you appear in the workplace and change your password.</p>
        </div>
      </header>

      <div className="admin-profile-layout">
        <aside className="admin-panel admin-profile-card">
          <AdminAvatar name={name} seed={user?.email} size="lg" />
          <h2>{name}</h2>
          <p className="admin-muted">{user?.email}</p>
          <RoleBadge role={isAdmin ? 'practice admin' : user?.role} />
        </aside>

        <form className="admin-panel admin-form" onSubmit={onSubmit}>
          <div className="admin-form-section">
          <h2>Details</h2>
          {error ? <p className="admin-error">{error}</p> : null}
          {success ? <p className="admin-success">{success}</p> : null}

          <div className="admin-form-row admin-form-row-2">
            <label>
              First name
              <input
                value={form.firstName}
                onChange={(e) => setForm((f) => ({ ...f, firstName: e.target.value }))}
              />
            </label>
            <label>
              Last name
              <input
                value={form.lastName}
                onChange={(e) => setForm((f) => ({ ...f, lastName: e.target.value }))}
              />
            </label>
          </div>

          <label>
            Phone
            <input
              type="tel"
              value={form.phone}
              onChange={(e) => setForm((f) => ({ ...f, phone: e.target.value }))}
              placeholder="Optional"
            />
          </label>

          <label>
            Email
            <input type="email" value={user?.email || ''} disabled readOnly />
          </label>

          </div>

          <div className="admin-divider" />

          <div className="admin-form-section">
          <h2>Password</h2>
          <p className="admin-muted admin-form-hint">Leave blank to keep your current password.</p>

          <label>
            Current password
            <input
              type="password"
              autoComplete="current-password"
              value={form.currentPassword}
              onChange={(e) => setForm((f) => ({ ...f, currentPassword: e.target.value }))}
            />
          </label>
          <div className="admin-form-row admin-form-row-2">
            <label>
              New password
              <input
                type="password"
                autoComplete="new-password"
                className={pwShort ? 'admin-input-error' : ''}
                value={form.newPassword}
                onChange={(e) => setForm((f) => ({ ...f, newPassword: e.target.value }))}
              />
              {pwShort ? <span className="admin-field-hint">At least 6 characters.</span> : null}
            </label>
            <label>
              Confirm new password
              <input
                type="password"
                autoComplete="new-password"
                className={pwMismatch ? 'admin-input-error' : ''}
                value={form.confirmPassword}
                onChange={(e) => setForm((f) => ({ ...f, confirmPassword: e.target.value }))}
              />
              {pwMismatch ? <span className="admin-field-hint">Passwords do not match.</span> : null}
            </label>
          </div>
          </div>

          <button type="submit" className="admin-primary-btn" disabled={saving}>
            {saving ? 'Saving…' : 'Save profile'}
          </button>
        </form>
      </div>
    </div>
  )
}
