import React, { useEffect, useState } from 'react'
import { workplaceApi } from '../../api/workplace'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { AdminAvatar, personName, StatusBadge } from './adminUi'
import './Admin.css'

const STATUSES = ['REQUESTED', 'SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW']

export default function AdminAppointments() {
  const { can } = useWorkplaceAuth()
  const canWrite = can('appointments', 'write')
  const [rows, setRows] = useState([])
  const [filter, setFilter] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const load = async (status = filter) => {
    setLoading(true)
    setError('')
    try {
      const data = await workplaceApi.listAppointments(status || undefined)
      setRows(data.appointments || [])
    } catch (err) {
      setError(err.message || 'Failed to load appointments')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const updateStatus = async (id, status) => {
    try {
      await workplaceApi.updateAppointment(id, { status })
      await load()
    } catch (err) {
      setError(err.message || 'Update failed')
    }
  }

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Care</p>
          <h1>Appointments</h1>
          <p className="admin-muted">Requests and scheduled visits across the practice.</p>
        </div>
        <select
          className={`admin-filter admin-filter--${filter.toLowerCase()}`}
          value={filter}
          onChange={(e) => {
            const v = e.target.value
            setFilter(v)
            load(v)
          }}
        >
          <option value="">All statuses</option>
          {STATUSES.map((s) => (
            <option key={s} value={s}>
              {s.replaceAll('_', ' ')}
            </option>
          ))}
        </select>
      </header>

      {error ? <p className="admin-error">{error}</p> : null}
      {loading ? (
        <p className="admin-muted">Loading…</p>
      ) : rows.length === 0 ? (
        <p className="admin-muted">No appointments found.</p>
      ) : (
        <div className="admin-table-wrap">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Patient</th>
                <th>Service</th>
                <th>Location</th>
                <th>Status</th>
                <th>When</th>
                {canWrite ? <th>Update</th> : null}
              </tr>
            </thead>
            <tbody>
              {rows.map((a) => {
                const name = personName(a.patient, a.patient?.phone)
                return (
                  <tr key={a.id}>
                    <td>
                      <div className="admin-person">
                        <AdminAvatar name={name} seed={a.patient?.phone || a.id} size="sm" />
                        <div className="admin-person-copy">
                          <strong>{name}</strong>
                          <p className="admin-muted">{a.patient?.phone}</p>
                        </div>
                      </div>
                    </td>
                    <td>{a.serviceName}</td>
                    <td>{a.locationName}</td>
                    <td>
                      <StatusBadge value={a.status} />
                    </td>
                    <td>
                      {a.scheduledAt
                        ? new Date(a.scheduledAt).toLocaleString()
                        : a.preferredAt || '—'}
                    </td>
                    {canWrite ? (
                      <td>
                        <select
                          className={`admin-filter admin-filter--${String(a.status).toLowerCase()}`}
                          value={a.status}
                          onChange={(e) => updateStatus(a.id, e.target.value)}
                        >
                          {STATUSES.map((s) => (
                            <option key={s} value={s}>
                              {s.replaceAll('_', ' ')}
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
        </div>
      )}
    </div>
  )
}
