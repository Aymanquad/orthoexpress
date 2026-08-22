const API_BASE = import.meta.env.VITE_API_URL || '/api'

export class ApiError extends Error {
  constructor(message, status) {
    super(message)
    this.status = status
  }
}

export async function apiFetch(path, options = {}) {
  const res = await fetch(`${API_BASE}${path}`, {
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
    ...options,
  })

  const data = await res.json().catch(() => ({}))
  if (!res.ok) {
    throw new ApiError(data.error || 'Request failed', res.status)
  }
  return data
}

export const authApi = {
  requestOtp: (phone) =>
    apiFetch('/auth/otp/request', { method: 'POST', body: JSON.stringify({ phone }) }),
  verifyOtp: (phone, code) =>
    apiFetch('/auth/otp/verify', { method: 'POST', body: JSON.stringify({ phone, code }) }),
  logout: () => apiFetch('/auth/logout', { method: 'POST' }),
  me: () => apiFetch('/auth/me'),
  updateProfile: (payload) =>
    apiFetch('/auth/me', { method: 'PATCH', body: JSON.stringify(payload) }),
}

export const appointmentsApi = {
  list: (filter = 'all') => apiFetch(`/appointments?filter=${filter}`),
  get: (id) => apiFetch(`/appointments/${id}`),
  request: (payload) =>
    apiFetch('/appointments/request', { method: 'POST', body: JSON.stringify(payload) }),
}

export const ordersApi = {
  save: (order) => apiFetch('/orders', { method: 'POST', body: JSON.stringify(order) }),
  list: () => apiFetch('/orders'),
}

export const recordsApi = {
  prescriptions: () => apiFetch('/records/prescriptions'),
  demographics: () => apiFetch('/records/demographics'),
  updateDemographicsContact: (payload) =>
    apiFetch('/records/demographics', { method: 'PATCH', body: JSON.stringify(payload) }),
}

