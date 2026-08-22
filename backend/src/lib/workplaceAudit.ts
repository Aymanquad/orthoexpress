import type { WorkplaceActor } from '../middleware/workplaceAuth.js'

function actorName(actor: WorkplaceActor) {
  return [actor.firstName, actor.lastName].filter(Boolean).join(' ') || actor.email
}

function actorId(actor: WorkplaceActor) {
  return actor.typ === 'admin' ? actor.adminId : actor.staffId!
}

export function auditUpdate(actor: WorkplaceActor) {
  return {
    updatedByType: actor.typ,
    updatedById: actorId(actor),
    updatedByName: actorName(actor),
  }
}

export function auditCreate(actor: WorkplaceActor) {
  const name = actorName(actor)
  const id = actorId(actor)
  return {
    createdByType: actor.typ,
    createdById: id,
    createdByName: name,
    updatedByType: actor.typ,
    updatedById: id,
    updatedByName: name,
  }
}

export function publicAuditFields(row: {
  updatedAt: Date
  updatedByType?: string | null
  updatedById?: string | null
  updatedByName?: string | null
  createdAt?: Date
  createdByType?: string | null
  createdById?: string | null
  createdByName?: string | null
}) {
  return {
    updatedAt: row.updatedAt.toISOString(),
    updatedByType: row.updatedByType ?? null,
    updatedById: row.updatedById ?? null,
    updatedByName: row.updatedByName ?? null,
    ...(row.createdAt
      ? {
          createdAt: row.createdAt.toISOString(),
          createdByType: row.createdByType ?? null,
          createdById: row.createdById ?? null,
          createdByName: row.createdByName ?? null,
        }
      : {}),
  }
}
