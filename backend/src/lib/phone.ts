/** Normalize US phone numbers to E.164 (+1XXXXXXXXXX) */
export function normalizePhone(input: string): string {
  const digits = input.replace(/\D/g, '')
  if (digits.length === 10) return `+1${digits}`
  if (digits.length === 11 && digits.startsWith('1')) return `+${digits}`
  if (input.startsWith('+') && digits.length >= 10) return `+${digits}`
  throw new Error('Invalid phone number')
}

export function formatPhoneDisplay(e164: string): string {
  const digits = e164.replace(/\D/g, '')
  const national = digits.length === 11 ? digits.slice(1) : digits
  if (national.length !== 10) return e164
  return `(${national.slice(0, 3)}) ${national.slice(3, 6)}-${national.slice(6)}`
}

export function splitFullName(name: string): { firstName: string; lastName: string } {
  const parts = name.trim().split(/\s+/)
  if (parts.length === 1) return { firstName: parts[0], lastName: '' }
  return { firstName: parts[0], lastName: parts.slice(1).join(' ') }
}
