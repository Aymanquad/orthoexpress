export type ModuleAccess = {
  read: boolean
  write: boolean
}

export const WORKPLACE_MODULES = ['appointments', 'orders', 'prescriptions', 'demographics'] as const
export type WorkplaceModule = (typeof WORKPLACE_MODULES)[number]

export type WorkplacePermissions = Record<WorkplaceModule, ModuleAccess>

function blank(): ModuleAccess {
  return { read: false, write: false }
}
function full(): ModuleAccess {
  return { read: true, write: true }
}

export const FULL_PERMISSIONS: WorkplacePermissions = {
  appointments: full(),
  orders: full(),
  prescriptions: full(),
  demographics: full(),
}

export const EMPTY_PERMISSIONS: WorkplacePermissions = {
  appointments: blank(),
  orders: blank(),
  prescriptions: blank(),
  demographics: blank(),
}

function asBool(v: unknown, fallback = false): boolean {
  return typeof v === 'boolean' ? v : fallback
}

function parseModule(raw: unknown): ModuleAccess {
  const obj = raw && typeof raw === 'object' ? (raw as Record<string, unknown>) : {}
  const access: ModuleAccess = {
    read: asBool(obj.read),
    write: asBool(obj.write),
  }
  if (access.write) access.read = true
  return access
}

export function parsePermissions(raw: string | null | undefined): WorkplacePermissions {
  if (!raw || !raw.trim()) {
    return {
      appointments: blank(),
      orders: blank(),
      prescriptions: blank(),
      demographics: blank(),
    }
  }
  try {
    const json = JSON.parse(raw) as Record<string, unknown>
    return {
      appointments: parseModule(json.appointments),
      orders: parseModule(json.orders),
      prescriptions: parseModule(json.prescriptions),
      demographics: parseModule(json.demographics),
    }
  } catch {
    return {
      appointments: blank(),
      orders: blank(),
      prescriptions: blank(),
      demographics: blank(),
    }
  }
}

export function serializePermissions(perms: WorkplacePermissions): string {
  return JSON.stringify({
    appointments: { read: Boolean(perms.appointments?.read), write: Boolean(perms.appointments?.write) },
    orders: { read: Boolean(perms.orders?.read), write: Boolean(perms.orders?.write) },
    prescriptions: { read: Boolean(perms.prescriptions?.read), write: Boolean(perms.prescriptions?.write) },
    demographics: { read: Boolean(perms.demographics?.read), write: Boolean(perms.demographics?.write) },
  })
}

export function normalizePermissionsInput(input: unknown): WorkplacePermissions {
  if (!input || typeof input !== 'object') {
    return {
      appointments: blank(),
      orders: blank(),
      prescriptions: blank(),
      demographics: blank(),
    }
  }
  const obj = input as Record<string, unknown>
  return {
    appointments: parseModule(obj.appointments),
    orders: parseModule(obj.orders),
    prescriptions: parseModule(obj.prescriptions),
    demographics: parseModule(obj.demographics),
  }
}
