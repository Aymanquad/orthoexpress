import React, { useEffect, useState } from 'react'
import { workplaceApi } from '../../api/workplace'
import { ActiveDot, AdminAvatar, DEFAULT_PERMISSIONS, MODULE_LABELS, personName, RoleBadge } from './adminUi'
import './Admin.css'

const ROLES = ['MANAGER', 'FRONT_DESK', 'CLINICAL', 'BILLING']
const MODULES = Object.keys(MODULE_LABELS)

const emptyForm = {
  email: '',
  password: '',
  firstName: '',
  lastName: '',
  phone: '',
  role: 'FRONT_DESK',
  isActive: true,
  permissions: { ...DEFAULT_PERMISSIONS },
}

function Switch({ checked, onChange, label }) {
  return (
    <label className="admin-switch" title={label}>
      <input type="checkbox" checked={checked} onChange={(e) => onChange(e.target.checked)} />
      <span />
    </label>
  )
}

function PermToggles({ value, onChange }) {
  const set = (module, key, checked) => {
    const next = {
      ...value,
      [module]: {
        ...(value[module] || { read: false, write: false }),
        [key]: checked,
        ...(key === 'write' && checked ? { read: true } : {}),
        ...(key === 'read' && !checked ? { write: false } : {}),
      },
    }
    onChange(next)
  }
  return (
    <div className="admin-perm-matrix">
      <div className="admin-perm-matrix-head">
        <span>Module</span>
        <span>Read</span>
        <span>Write</span>
      </div>
      {MODULES.map((mod) => (
        <div key={mod} className="admin-perm-matrix-row">
          <span>{MODULE_LABELS[mod]}</span>
          <Switch
            label={`${MODULE_LABELS[mod]} read`}
            checked={Boolean(value[mod]?.read)}
            onChange={(checked) => set(mod, 'read', checked)}
          />
          <Switch
            label={`${MODULE_LABELS[mod]} write`}
            checked={Boolean(value[mod]?.write)}
            onChange={(checked) => set(mod, 'write', checked)}
          />
        </div>
      ))}
    </div>
  )
}

export default function AdminStaff() {
  const [staff, setStaff] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [form, setForm] = useState(emptyForm)
  const [editingId, setEditingId] = useState(null)
  const [saving, setSaving] = useState(false)

  const load = async () => {
    setLoading(true)
    setError('')
    try {
      const data = await workplaceApi.listStaff()
      setStaff(data.staff || [])
    } catch (err) {
      setError(err.message || 'Failed to load staff')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  const startCreate = () => {
    setEditingId(null)
    setForm({
      ...emptyForm,
      permissions: {
        appointments: { read: true, write: false },
        orders: { read: false, write: false },
        prescriptions: { read: false, write: false },
        demographics: { read: false, write: false },
      },
    })
  }

  const startEdit = (row) => {
    setEditingId(row.id)
    setForm({
      email: row.email,
      password: '',
      firstName: row.firstName || '',
      lastName: row.lastName || '',
      phone: row.phone || '',
      role: row.role,
      isActive: row.isActive,
      permissions: { ...DEFAULT_PERMISSIONS, ...(row.permissions || {}) },
    })
  }

  const onSubmit = async (e) => {
    e.preventDefault()
    setSaving(true)
    setError('')
    try {
      const payload = {
        email: form.email,
        firstName: form.firstName,
        lastName: form.lastName,
        phone: form.phone,
        role: form.role,
        isActive: form.isActive,
        permissions: form.permissions,
      }
      if (editingId) {
        if (form.password.trim()) payload.password = form.password
        await workplaceApi.updateStaff(editingId, payload)
      } else {
        payload.password = form.password
        await workplaceApi.createStaff(payload)
      }
      setForm(emptyForm)
      setEditingId(null)
      await load()
    } catch (err) {
      setError(err.message || 'Save failed')
    } finally {
      setSaving(false)
    }
  }

  const deactivate = async (id) => {
    if (!window.confirm('Deactivate this staff account?')) return
    await workplaceApi.deactivateStaff(id)
    await load()
  }

  const hardDelete = async (id) => {
    if (!window.confirm('Permanently delete this staff account?')) return
    await workplaceApi.deleteStaff(id)
    await load()
  }

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Team</p>
          <h1>Staff</h1>
          <p className="admin-muted">Create logins, assign roles, and limit what each person can see.</p>
        </div>
        {editingId ? (
          <button type="button" className="admin-secondary-btn" onClick={startCreate}>
            New staff
          </button>
        ) : null}
      </header>

      {error ? <p className="admin-error">{error}</p> : null}

      <div className="admin-split">
        <form className="admin-panel admin-form" onSubmit={onSubmit}>
          <h2>{editingId ? 'Edit staff' : 'Add staff'}</h2>
          <label>
            Email
            <input
              type="email"
              required
              value={form.email}
              onChange={(e) => setForm((f) => ({ ...f, email: e.target.value }))}
            />
          </label>
          <label>
            Password
            <input
              type="password"
              required={!editingId}
              minLength={6}
              placeholder={editingId ? 'Leave blank to keep current' : ''}
              value={form.password}
              onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))}
            />
          </label>
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
            Role
            <select
              value={form.role}
              onChange={(e) => setForm((f) => ({ ...f, role: e.target.value }))}
            >
              {ROLES.map((r) => (
                <option key={r} value={r}>
                  {r.replaceAll('_', ' ')}
                </option>
              ))}
            </select>
          </label>
          <div className="admin-perm-block">
            <p className="admin-perm-label">Access</p>
            <PermToggles
              value={form.permissions}
              onChange={(permissions) => setForm((f) => ({ ...f, permissions }))}
            />
          </div>
          <label className="admin-check">
            <input
              type="checkbox"
              checked={form.isActive}
              onChange={(e) => setForm((f) => ({ ...f, isActive: e.target.checked }))}
            />
            <ActiveDot active={form.isActive} />
          </label>
          <button type="submit" className="admin-primary-btn" disabled={saving}>
            {saving ? 'Saving…' : editingId ? 'Update staff' : 'Create staff'}
          </button>
        </form>

        <div className="admin-panel">
          <h2>Team</h2>
          {loading ? (
            <p className="admin-muted">Loading…</p>
          ) : staff.length === 0 ? (
            <p className="admin-muted">No staff yet. Add the first login on the left.</p>
          ) : (
            <ul className="admin-list">
              {staff.map((row) => {
                const name = personName(row, row.email)
                return (
                <li key={row.id}>
                  <div className="admin-person">
                    <AdminAvatar name={name} seed={row.email} />
                    <div className="admin-list-copy">
                      <strong>{name}</strong>
                      <p className="admin-muted">{row.email}</p>
                      <p style={{ marginTop: 6, display: 'flex', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
                        <RoleBadge role={row.role} />
                        <ActiveDot active={row.isActive} />
                      </p>
                    </div>
                  </div>
                  <div className="admin-row-actions">
                    <button type="button" onClick={() => startEdit(row)}>
                      Edit
                    </button>
                    {row.isActive ? (
                      <button type="button" onClick={() => deactivate(row.id)}>
                        Deactivate
                      </button>
                    ) : null}
                    <button type="button" className="danger" onClick={() => hardDelete(row.id)}>
                      Delete
                    </button>
                  </div>
                </li>
                )
              })}
            </ul>
          )}
        </div>
      </div>
    </div>
  )
}
