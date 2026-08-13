/** Optional external patient portal URL — set VITE_PATIENT_PORTAL_URL when live */
export const PATIENT_PORTAL_URL = import.meta.env.VITE_PATIENT_PORTAL_URL || ''

export function hasPatientPortalLogin() {
  return Boolean(PATIENT_PORTAL_URL?.trim())
}
