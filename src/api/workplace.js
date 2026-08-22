import { apiFetch } from './client'

export const workplaceApi = {
  login: (email, password) =>
    apiFetch('/workplace/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    }),
  me: () => apiFetch('/workplace/auth/me'),
  updateProfile: (payload) =>
    apiFetch('/workplace/auth/profile', {
      method: 'PATCH',
      body: JSON.stringify(payload),
    }),
  logout: () => apiFetch('/workplace/auth/logout', { method: 'POST' }),
  listStaff: () => apiFetch('/workplace/staff'),
  createStaff: (payload) =>
    apiFetch('/workplace/staff', { method: 'POST', body: JSON.stringify(payload) }),
  updateStaff: (id, payload) =>
    apiFetch(`/workplace/staff/${id}`, { method: 'PATCH', body: JSON.stringify(payload) }),
  deactivateStaff: (id) => apiFetch(`/workplace/staff/${id}`, { method: 'DELETE' }),
  deleteStaff: (id) => apiFetch(`/workplace/staff/${id}?hard=1`, { method: 'DELETE' }),
  listAppointments: (status) =>
    apiFetch(`/workplace/appointments${status ? `?status=${encodeURIComponent(status)}` : ''}`),
  updateAppointment: (id, payload) =>
    apiFetch(`/workplace/appointments/${id}`, {
      method: 'PATCH',
      body: JSON.stringify(payload),
    }),
  listOrders: () => apiFetch('/workplace/orders'),
  updateOrder: (id, payload) =>
    apiFetch(`/workplace/orders/${id}`, { method: 'PATCH', body: JSON.stringify(payload) }),
  listPatients: (q) =>
    apiFetch(`/workplace/patients${q ? `?q=${encodeURIComponent(q)}` : ''}`),
  listPrescriptions: (params = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.patientId) qs.set('patientId', params.patientId)
    const suffix = qs.toString() ? `?${qs}` : ''
    return apiFetch(`/workplace/prescriptions${suffix}`)
  },
  createPrescription: (payload) =>
    apiFetch('/workplace/prescriptions', { method: 'POST', body: JSON.stringify(payload) }),
  updatePrescription: (id, payload) =>
    apiFetch(`/workplace/prescriptions/${id}`, { method: 'PATCH', body: JSON.stringify(payload) }),
  listDemographics: (q) =>
    apiFetch(`/workplace/demographics/patients${q ? `?q=${encodeURIComponent(q)}` : ''}`),
  updateDemographics: (patientId, payload) =>
    apiFetch(`/workplace/demographics/${patientId}`, {
      method: 'PATCH',
      body: JSON.stringify(payload),
    }),
}
