/**
 * Quality tiers for the skeleton viewer.
 * Constrained devices drop bloom/extra passes so motion stays smooth.
 */
export function detectViewerQuality() {
  if (typeof window === 'undefined' || typeof navigator === 'undefined') {
    return { tier: 'high', bloom: true, pixelRatioCap: 2 }
  }

  const mobile = /Mobi|Android|iPhone|iPad/i.test(navigator.userAgent)
  const saveData = Boolean(navigator.connection?.saveData)
  const lowMem = typeof navigator.deviceMemory === 'number' && navigator.deviceMemory <= 4
  const lowCpu = typeof navigator.hardwareConcurrency === 'number' && navigator.hardwareConcurrency <= 4
  const constrained = mobile || saveData || lowMem || lowCpu

  if (constrained) {
    return { tier: 'low', bloom: false, pixelRatioCap: 1.5 }
  }
  return { tier: 'high', bloom: true, pixelRatioCap: 2 }
}
