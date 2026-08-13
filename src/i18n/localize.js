/** Resolve a bilingual value or plain string for the active language.
 *  English never falls back to Spanish. Spanish falls back to English. */
export function localize(value, lang = 'en') {
  if (value == null) return ''
  if (typeof value === 'string' || typeof value === 'number') return String(value)
  if (typeof value === 'object' && ('en' in value || 'es' in value)) {
    if (lang === 'es') return value.es ?? value.en ?? ''
    return value.en ?? ''
  }
  return String(value)
}

/** Resolve a bilingual array object or an array of bilingual or plain strings */
export function localizeArray(items, lang = 'en') {
  if (items == null) return []
  if (
    typeof items === 'object' &&
    !Array.isArray(items) &&
    ('en' in items || 'es' in items)
  ) {
    if (lang === 'es') return items.es ?? items.en ?? []
    return items.en ?? []
  }
  if (!Array.isArray(items)) return []
  return items.map((item) => localize(item, lang))
}
