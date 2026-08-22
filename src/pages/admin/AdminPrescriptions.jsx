import React, { useEffect, useState } from 'react'
import { workplaceApi } from '../../api/workplace'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { AdminAvatar, formatAuditLine, personName, StatusBadge } from './adminUi'
import './Admin.css'

const STATUSES = ['ACTIVE', 'COMPLETED', 'DISCONTINUED']
const empty = {
  patientId: '',
  medication: '',
  dosage: '',
  frequency: '',
  instructions: '',
  prescribedBy: '',
  status: 'ACTIVE',
}

export default function AdminPrescriptions() {
  const { can } = useWorkplaceAuth()
  const canWrite = can('prescriptions', 'write')
  const [rows, setRows] = useState([])
  const [patients, setPatients] = useState([])
  const [filter, setFilter] = useState('ACTIVE')
  const [form, setForm] = useState(empty)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')

  const load = async (status = filter) => {
    setLoading(true)
    setError('')
    try {
      const [rx, pts] = await Promise.all([
        workplaceApi.listPrescriptions({ status: status || undefined }),
        workplaceApi.listPatients().catch(() => ({ patients: [] })),
      ])
      setRows(rx.prescriptions || [])
      setPatients(pts.patients || [])
    } catch (err) {
      setError(err.message || 'Failed to load prescriptions')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const onSubmit = async (e) => {
    e.preventDefault()
    setSaving(true)
    setError('')
    try {
      await workplaceApi.createPrescription(form)
      setForm(empty)
      await load()
    } catch (err) {
      setError(err.message || 'Could not save prescription')
    } finally {
      setSaving(false)
    }
  }

  const updateStatus = async (id, status) => {
    try {
      await workplaceApi.updatePrescription(id, { status })
      await load()
    } catch (err) {
      setError(err.message || 'Update failed')
    }
  }

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Clinical</p>
          <h1>Prescriptions</h1>
          <p className="admin-muted">Active and historical medications for clinic patients.</p>
        </div>
        <select
          className="admin-filter"
          value={filter}
          onChange={(e) => {
            setFilter(e.target.value)
            load(e.target.value)
          }}
        >
          <option value="">All</option>
          {STATUSES.map((s) => (
            <option key={s} value={s}>
              {s === 'DISCONTINUED' ? 'Discontinued' : s.charAt(0) + s.slice(1).toLowerCase()}
            </option>
          ))}
        </select>
      </header>

      {error ? <p className="admin-error">{error}</p> : null}

      <div className="admin-split">
        {canWrite ? (
          <form className="admin-panel admin-form" onSubmit={onSubmit}>
            <h2>New prescription</h2>
            <label>
              Patient
              <select
                required
                value={form.patientId}
                onChange={(e) => setForm((f) => ({ ...f, patientId: e.target.value }))}
              >
                <option value="">Select patient</option>
                {patients.map((p) => (
                  <option key={p.id} value={p.id}>
                    {personName(p, p.phone)} · {p.phone}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Medication
              <input
                required
                value={form.medication}
                onChange={(e) => setForm((f) => ({ ...f, medication: e.target.value }))}
              />
            </label>
            <div className="admin-form-row admin-form-row-2">
              <label>
                Dosage
                <input
                  required
                  value={form.dosage}
                  onChange={(e) => setForm((f) => ({ ...f, dosage: e.target.value }))}
                />
              </label>
              <label>
                Frequency
                <input
                  value={form.frequency}
                  placeholder="e.g. Twice daily"
                  onChange={(e) => setForm((f) => ({ ...f, frequency: e.target.value }))}
                />
              </label>
            </div>
            <label>
              Instructions
              <input
                value={form.instructions}
                onChange={(e) => setForm((f) => ({ ...f, instructions: e.target.value }))}
              />
            </label>
            <label>
              Prescribed by
              <input
                value={form.prescribedBy}
                onChange={(e) => setForm((f) => ({ ...f, prescribedBy: e.target.value }))}
              />
            </label>
            <button type="submit" className="admin-primary-btn" disabled={saving}>
              {saving ? 'Saving…' : 'Add prescription'}
            </button>
          </form>
        ) : (
          <div className="admin-panel">
            <h2>Read only</h2>
            <p className="admin-muted">You can view prescriptions but cannot add or change them.</p>
          </div>
        )}

        <div className="admin-table-wrap">
          {loading ? (
            <p className="admin-muted" style={{ padding: 16 }}>Loading…</p>
          ) : rows.length === 0 ? (
            <p className="admin-muted" style={{ padding: 16 }}>No prescriptions found.</p>
          ) : (
            <table className="admin-table">
              <thead>
                <tr>
                  <th>Patient</th>
                  <th>Medication</th>
                  <th>Status</th>
                  <th>Prescribed by</th>
                  {canWrite ? <th>Update</th> : null}
                </tr>
              </thead>
              <tbody>
                {rows.map((row) => {
                  const name = personName(row.patient, row.patient?.phone)
                  const audit = formatAuditLine(row)
                  return (
                    <tr key={row.id}>
                      <td>
                        <div className="admin-person">
                          <AdminAvatar name={name} seed={row.patient?.phone || row.id} size="sm" />
                          <div className="admin-person-copy">
                            <strong>{name}</strong>
                            <p className="admin-muted">{row.patient?.phone}</p>
                          </div>
                        </div>
                      </td>
                      <td>
                        <strong>{row.medication}</strong>
                        <div className="admin-muted">{row.dosage}</div>
                        {row.frequency ? <div className="admin-muted">{row.frequency}</div> : null}
                        {audit ? <div className="admin-audit-line">{audit}</div> : null}
                      </td>
                      <td>
                        <StatusBadge value={row.status} />
                      </td>
                      <td>{row.prescribedBy || '—'}</td>
                      {canWrite ? (
                        <td>
                          <select
                            className={`admin-filter admin-filter--${String(row.status).toLowerCase()}`}
                            value={row.status}
                            onChange={(e) => updateStatus(row.id, e.target.value)}
                          >
                            {STATUSES.map((s) => (
                              <option key={s} value={s}>
                                {s === 'DISCONTINUED' ? 'Discontinued' : s.charAt(0) + s.slice(1).toLowerCase()}
                              </option>
                            ))}
                          </select>
                        </td>
                      ) : null}
                    </tr>
                  )
                })}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  )
}
