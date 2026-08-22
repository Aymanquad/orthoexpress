import React, { useEffect, useState } from 'react'
import { workplaceApi } from '../../api/workplace'
import { useWorkplaceAuth } from '../../context/WorkplaceAuthContext'
import { AdminAvatar, personName, StatusBadge } from './adminUi'
import './Admin.css'

const ORDER_STATUSES = ['confirmed', 'processing', 'shipped', 'delivered', 'cancelled']

export default function AdminOrders() {
  const { can } = useWorkplaceAuth()
  const canWrite = can('orders', 'write')
  const [rows, setRows] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const load = async () => {
    setLoading(true)
    setError('')
    try {
      const data = await workplaceApi.listOrders()
      setRows(data.orders || [])
    } catch (err) {
      setError(err.message || 'Failed to load orders')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  const updateStatus = async (id, status) => {
    try {
      await workplaceApi.updateOrder(id, { status })
      await load()
    } catch (err) {
      setError(err.message || 'Update failed')
    }
  }

  const money = (cents) => `$${((cents || 0) / 100).toFixed(2)}`

  return (
    <div className="admin-page admin-page-enter">
      <header className="admin-page-header">
        <div>
          <p className="admin-kicker">Shop</p>
          <h1>Orders</h1>
          <p className="admin-muted">Patient shop orders linked to this practice.</p>
        </div>
      </header>

      {error ? <p className="admin-error">{error}</p> : null}
      {loading ? (
        <p className="admin-muted">Loading…</p>
      ) : rows.length === 0 ? (
        <p className="admin-muted">No orders found.</p>
      ) : (
        <div className="admin-table-wrap">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Order</th>
                <th>Patient</th>
                <th>Total</th>
                <th>Status</th>
                <th>Created</th>
                {canWrite ? <th>Update</th> : null}
              </tr>
            </thead>
            <tbody>
              {rows.map((o) => {
                const patientName =
                  [o.patient?.firstName, o.patient?.lastName].filter(Boolean).join(' ') ||
                  o.phone ||
                  '—'
                return (
                  <tr key={o.id}>
                    <td>
                      <strong>{o.id}</strong>
                    </td>
                    <td>
                      <div className="admin-person">
                        <AdminAvatar name={patientName} seed={o.phone || o.id} size="sm" />
                        <div className="admin-person-copy">
                          <strong>{patientName}</strong>
                          <p className="admin-muted">{o.phone}</p>
                        </div>
                      </div>
                    </td>
                    <td>{money(o.totalCents)}</td>
                    <td>
                      <StatusBadge value={o.status} />
                    </td>
                    <td>{new Date(o.createdAt).toLocaleString()}</td>
                    {canWrite ? (
                      <td>
                        <select
                          className={`admin-filter admin-filter--${String(o.status).toLowerCase()}`}
                          value={ORDER_STATUSES.includes(o.status) ? o.status : o.status}
                          onChange={(e) => updateStatus(o.id, e.target.value)}
                        >
                          {!ORDER_STATUSES.includes(o.status) ? (
                            <option value={o.status}>{o.status}</option>
                          ) : null}
                          {ORDER_STATUSES.map((s) => (
                            <option key={s} value={s}>
                              {s}
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
