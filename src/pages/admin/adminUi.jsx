import React from 'react'
import {
  FiActivity,
  FiCalendar,
  FiClipboard,
  FiHome,
  FiLogOut,
  FiPackage,
  FiShield,
  FiUsers,
  FiUser,
} from 'react-icons/fi'

export const NAV_ICONS = {
  dashboard: FiHome,
  staff: FiUsers,
  appointments: FiCalendar,
  orders: FiPackage,
  prescriptions: FiClipboard,
  demographics: FiActivity,
  profile: FiUser,
  logout: FiLogOut,
  security: FiShield,
}

export function personName(person, fallback = '—') {
  if (!person) return fallback
  const name = [person.firstName, person.lastName].filter(Boolean).join(' ')
  return name || person.email || person.phone || fallback
}

export function initialsFrom(name) {
  const parts = String(name || '')
    .trim()
    .split(/\s+/)
    .filter(Boolean)
  if (!parts.length) return 'OE'
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase()
  return `${parts[0][0]}${parts[parts.length - 1][0]}`.toUpperCase()
}

const AVATAR_TONES = ['navy', 'green', 'sky', 'amber', 'plum']

export function avatarTone(seed) {
  const s = String(seed || '')
  let n = 0
  for (let i = 0; i < s.length; i += 1) n = (n + s.charCodeAt(i)) % AVATAR_TONES.length
  return AVATAR_TONES[n]
}

export function AdminAvatar({ name, seed, size = 'md' }) {
  const label = initialsFrom(name)
  return (
    <span className={`admin-avatar admin-avatar--${size} admin-avatar--${avatarTone(seed || name)}`}>
      {label}
    </span>
  )
}

export function StatusBadge({ value, kind = 'status' }) {
  const raw = String(value || '')
  const key = raw.toLowerCase().replace(/[\s_]+/g, '-')
  const labels = {
    ACTIVE: 'Active',
    COMPLETED: 'Completed',
    DISCONTINUED: 'Discontinued',
    STOPPED: 'Discontinued',
  }
  const label = labels[raw] || raw.replaceAll('_', ' ')
  return <span className={`admin-badge admin-badge--${kind}-${key}`}>{label}</span>
}

export function formatAuditLine(record) {
  if (!record?.updatedAt) return null
  const date = new Date(record.updatedAt).toLocaleString(undefined, {
    dateStyle: 'medium',
    timeStyle: 'short',
  })
  if (record.updatedByName) {
    return `Last updated by ${record.updatedByName} on ${date}`
  }
  return `Last updated on ${date}`
}

export function RoleBadge({ role }) {
  const key = String(role || 'staff').toLowerCase().replace(/[\s_]+/g, '-')
  return <span className={`admin-badge admin-badge--role-${key}`}>{String(role || '').replaceAll('_', ' ')}</span>
}

export function ActiveDot({ active }) {
  return (
    <span className={`admin-status-dot ${active ? 'is-active' : 'is-inactive'}`}>
      <i />
      {active ? 'Active' : 'Inactive'}
    </span>
  )
}

export const MODULE_LABELS = {
  appointments: 'Appointments',
  orders: 'Orders',
  prescriptions: 'Prescriptions',
  demographics: 'Demographics',
}

export const DEFAULT_PERMISSIONS = {
  appointments: { read: true, write: false },
  orders: { read: false, write: false },
  prescriptions: { read: false, write: false },
  demographics: { read: false, write: false },
}
