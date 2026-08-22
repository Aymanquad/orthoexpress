export function staffSlug(user) {
  const raw =
    [user?.firstName, user?.lastName].filter(Boolean).join(' ') ||
    String(user?.email || '').split('@')[0] ||
    'staff'
  const slug = raw
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
  return slug || 'staff'
}

export function isAdminUser(user) {
  return Boolean(user && (user.typ === 'admin' || user.canManageStaff))
}

export function workplaceHome(user) {
  if (!user) return '/admin/login'
  if (isAdminUser(user)) return '/admin'
  const id = user.staffId
  if (!id) return '/admin/login'
  return `/staff/${staffSlug(user)}/${id}`
}

export function workplacePath(user, page = '') {
  const home = workplaceHome(user)
  if (!page) return home
  return `${home}/${page}`
}

export function formatRole(role) {
  if (!role) return 'Staff'
  return String(role).replaceAll('_', ' ')
}
