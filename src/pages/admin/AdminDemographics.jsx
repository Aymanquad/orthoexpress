import React, { useEffect, useState } from 'react'
import { workplaceApi } from '../../api/workplace'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { AdminAvatar, formatAuditLine, personName } from './adminUi'
import './Admin.css'

const emptyDemo = {
  dateOfBirth: '',
  sex: '',
  address: '',
  city: '',
  state: '',
  country: '',
  zip: '',
  emergencyName: '',
  emergencyPhone: '',
  emergencyRelationship: '',
  insuranceProvider: '',
  insurancePolicyNumber: '',
  allergies: '',
  bloodType: '',
  conditions: '',
  notes: '',
}

export default function AdminDemographics() {
  const { can } = useWorkplaceAuth()
  const canWrite = can('demographics', 'write')
  const [patients, setPatients] = useState([])
  const [selected, setSelected] = useState(null)
  const [form, setForm] = useState(emptyDemo)
  const [query, setQuery] = useState('')
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const load = async (q = query) => {
    setLoading(true)
    setError('')
    try {
      const data = await workplaceApi.listDemographics(q)
      setPatients(data.patients || [])
      if (selected) {
        const fresh = (data.patients || []).find((p) => p.id === selected.id)
        if (fresh) open(fresh, false)
      }
    } catch (err) {
      setError(err.message || 'Failed to load records')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const open = (row, clearSuccess = true) => {
    setSelected(row)
    if (clearSuccess) setSuccess('')
    setForm({
      dateOfBirth: row.demographics?.dateOfBirth || '',
      sex: row.demographics?.sex || '',
      address: row.demographics?.address || '',
      city: row.demographics?.city || '',
      state: row.demographics?.state || '',
      country: row.demographics?.country || '',
      zip: row.demographics?.zip || '',
      emergencyName: row.demographics?.emergencyName || '',
      emergencyPhone: row.demographics?.emergencyPhone || '',
      emergencyRelationship: row.demographics?.emergencyRelationship || '',
      insuranceProvider: row.demographics?.insuranceProvider || '',
      insurancePolicyNumber: row.demographics?.insurancePolicyNumber || '',
      allergies: row.demographics?.allergies || '',
      bloodType: row.demographics?.bloodType || '',
      conditions: row.demographics?.conditions || '',
      notes: row.demographics?.notes || '',
    })
  }

  const onSubmit = async (e) => {
    e.preventDefault()
    if (!selected) return
    setSaving(true)
    setError('')
    setSuccess('')
    try {
      const res = await workplaceApi.updateDemographics(selected.id, form)
      setSuccess('Record saved.')
      if (res?.patient) open(res.patient, false)
      await load()
    } catch (err) {
      setError(err.message || 'Save failed')
    } finally {
      setSaving(false)
    }
  }

  const auditLine = selected?.demographics ? formatAuditLine(selected.demographics) : null

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Clinical</p>
          <h1>Demographics</h1>
          <p className="admin-muted">Contact, emergency, allergy, and history details for each patient.</p>
        </div>
        <input
          className="admin-filter"
          placeholder="Search name or phone"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') load(query)
          }}
        />
      </header>

      {error ? <p className="admin-error">{error}</p> : null}

      <div className="admin-split">
        <div className="admin-panel">
          <h2>Patients</h2>
          {loading ? (
            <p className="admin-muted">Loading…</p>
          ) : (
            <ul className="admin-list">
              {patients.map((row) => {
                const name = personName(row, row.phone)
                return (
                  <li key={row.id}>
                    <div className="admin-person">
                      <AdminAvatar name={name} seed={row.phone} size="sm" />
                      <div className="admin-list-copy">
                        <strong>{name}</strong>
                        <p className="admin-muted">{row.phone}</p>
                      </div>
                    </div>
                    <div className="admin-row-actions">
                      <button type="button" onClick={() => open(row)}>
                        {selected?.id === row.id ? 'Editing' : 'Open'}
                      </button>
                    </div>
                  </li>
                )
              })}
            </ul>
          )}
        </div>

        <form className="admin-panel admin-form" onSubmit={onSubmit}>
          <h2>{selected ? personName(selected, selected.phone) : 'Select a patient'}</h2>
          {!selected ? (
            <p className="admin-muted">Choose a patient to view or update their record.</p>
          ) : (
            <>
              {auditLine ? <p className="admin-audit-line">{auditLine}</p> : null}
              {success ? <p className="admin-success">{success}</p> : null}
              <div className="admin-form-section">
                <h2>Identity</h2>
                <div className="admin-form-row admin-form-row-2">
                  <label>
                    Date of birth
                    <input
                      type="date"
                      disabled={!canWrite}
                      value={form.dateOfBirth}
                      onChange={(e) => setForm((f) => ({ ...f, dateOfBirth: e.target.value }))}
                    />
                  </label>
                  <label>
                    Sex
                    <input
                      disabled={!canWrite}
                      value={form.sex}
                      onChange={(e) => setForm((f) => ({ ...f, sex: e.target.value }))}
                    />
                  </label>
                </div>
                <label>
                  Blood type
                  <input
                    disabled={!canWrite}
                    value={form.bloodType}
                    placeholder="e.g. O+"
                    onChange={(e) => setForm((f) => ({ ...f, bloodType: e.target.value }))}
                  />
                </label>
              </div>
              <div className="admin-form-section">
                <h2>Address</h2>
                <label>
                  Street address
                  <input
                    disabled={!canWrite}
                    value={form.address}
                    onChange={(e) => setForm((f) => ({ ...f, address: e.target.value }))}
                  />
                </label>
                <div className="admin-form-row admin-form-row-2">
                  <label>
                    City
                    <input
                      disabled={!canWrite}
                      value={form.city}
                      onChange={(e) => setForm((f) => ({ ...f, city: e.target.value }))}
                    />
                  </label>
                  <label>
                    State
                    <input
                      disabled={!canWrite}
                      value={form.state}
                      onChange={(e) => setForm((f) => ({ ...f, state: e.target.value }))}
                      placeholder="CA"
                    />
                  </label>
                </div>
                <div className="admin-form-row admin-form-row-2">
                  <label>
                    ZIP / postal
                    <input
                      disabled={!canWrite}
                      value={form.zip}
                      onChange={(e) => setForm((f) => ({ ...f, zip: e.target.value }))}
                    />
                  </label>
                  <label>
                    Country
                    <input
                      disabled={!canWrite}
                      value={form.country}
                      onChange={(e) => setForm((f) => ({ ...f, country: e.target.value }))}
                    />
                  </label>
                </div>
              </div>
              <div className="admin-form-section">
                <h2>Emergency contact</h2>
                <div className="admin-form-row admin-form-row-2">
                  <label>
                    Name
                    <input
                      disabled={!canWrite}
                      value={form.emergencyName}
                      onChange={(e) => setForm((f) => ({ ...f, emergencyName: e.target.value }))}
                    />
                  </label>
                  <label>
                    Phone
                    <input
                      disabled={!canWrite}
                      value={form.emergencyPhone}
                      onChange={(e) => setForm((f) => ({ ...f, emergencyPhone: e.target.value }))}
                    />
                  </label>
                </div>
                <label>
                  Relationship
                  <input
                    disabled={!canWrite}
                    value={form.emergencyRelationship}
                    placeholder="Spouse, parent, etc."
                    onChange={(e) => setForm((f) => ({ ...f, emergencyRelationship: e.target.value }))}
                  />
                </label>
              </div>
              <div className="admin-form-section">
                <h2>Insurance</h2>
                <div className="admin-form-row admin-form-row-2">
                  <label>
                    Provider
                    <input
                      disabled={!canWrite}
                      value={form.insuranceProvider}
                      onChange={(e) => setForm((f) => ({ ...f, insuranceProvider: e.target.value }))}
                    />
                  </label>
                  <label>
                    Policy / member #
                    <input
                      disabled={!canWrite}
                      value={form.insurancePolicyNumber}
                      onChange={(e) => setForm((f) => ({ ...f, insurancePolicyNumber: e.target.value }))}
                    />
                  </label>
                </div>
              </div>
              <div className="admin-form-section">
                <h2>Clinical notes</h2>
                <label>
                  Allergies
                  <input
                    disabled={!canWrite}
                    value={form.allergies}
                    onChange={(e) => setForm((f) => ({ ...f, allergies: e.target.value }))}
                  />
                </label>
                <label>
                  Conditions
                  <input
                    disabled={!canWrite}
                    value={form.conditions}
                    onChange={(e) => setForm((f) => ({ ...f, conditions: e.target.value }))}
                  />
                </label>
                {canWrite ? (
                  <label>
                    Internal notes (staff only)
                    <input
                      value={form.notes}
                      onChange={(e) => setForm((f) => ({ ...f, notes: e.target.value }))}
                    />
                  </label>
                ) : null}
              </div>
              {canWrite ? (
                <button type="submit" className="admin-primary-btn" disabled={saving}>
                  {saving ? 'Saving…' : 'Save record'}
                </button>
              ) : (
                <p className="admin-muted">Read-only access.</p>
              )}
            </>
          )}
        </form>
      </div>
    </div>
  )
}
