import type { Request, Response, NextFunction } from 'express'

type RateBucket = { count: number; resetAt: number }

const buckets = new Map<string, RateBucket>()

export function rateLimit(keyPrefix: string, max: number, windowMs: number) {
  return (req: Request, res: Response, next: NextFunction) => {
    const key = `${keyPrefix}:${req.ip}:${JSON.stringify(req.body?.phone ?? '')}`
    const now = Date.now()
    const bucket = buckets.get(key)

    if (!bucket || now > bucket.resetAt) {
      buckets.set(key, { count: 1, resetAt: now + windowMs })
      return next()
    }

    if (bucket.count >= max) {
      return res.status(429).json({ error: 'Too many requests. Please try again later.' })
    }

    bucket.count += 1
    next()
  }
}
