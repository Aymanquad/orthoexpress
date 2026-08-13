/** Convert display phone to tel: href (handles US + international) */
export function toTelLink(phone) {
  if (!phone) return ''
  const digits = phone.replace(/\D/g, '')
  if (phone.trim().startsWith('+')) {
    return `tel:+${digits}`
  }
  if (digits.length === 10) {
    return `tel:+1${digits}`
  }
  return `tel:+${digits}`
}

/** Google Maps directions/search URL for a location */
export function getMapsDirectionsUrl(location) {
  const query = encodeURIComponent(`${location.address}, ${location.city}`)
  return `https://www.google.com/maps/search/?api=1&query=${query}`
}

/** Today's date as YYYY-MM-DD for date input min */
export function getTodayDateString() {
  return new Date().toISOString().split('T')[0]
}
