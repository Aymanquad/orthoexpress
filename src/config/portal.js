/** Patient portal — internal OTP login; optional legacy external URL override */
export const PATIENT_PORTAL_URL = import.meta.env.VITE_PATIENT_PORTAL_URL || ''

/** True when a legacy external portal URL is configured */
export function hasExternalPortalUrl() {
  return Boolean(PATIENT_PORTAL_URL?.trim())
}

/** Internal portal is always available */
export function hasPatientPortalLogin() {
  return true
}

export const PORTAL_LOGIN_PATH = '/portal/login'
export const PORTAL_DASHBOARD_PATH = '/portal'
