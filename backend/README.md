# OrthoExpress Patient Portal API

Node + Express + Prisma + PostgreSQL backend for phone OTP login and appointment management.

## Quick start

```bash
# 1. Start Postgres (optional — local dev uses SQLite by default)
# docker compose up -d

# 2. Install & configure
cp .env.example .env
npm install

# 3. Migrate & seed
npm run db:push
npm run db:seed

# 4. Run API
npm run dev
```

From project root, run both web + API:

```bash
npm run dev:all
```

API runs at `http://localhost:4000`. Health check: `GET /api/health`.

## Demo patients (after seed)

| Phone | Name |
|-------|------|
| (213) 555-0100 | Alex Rivera |
| (213) 555-0200 | Jordan Kim |
| (213) 555-0300 | Sam Patel |

With `OTP_DEV_MODE=true`, OTP codes are printed to the API console.

## Endpoints

- `POST /api/auth/otp/request` — `{ phone }`
- `POST /api/auth/otp/verify` — `{ phone, code }` → sets `portal_token` cookie
- `POST /api/auth/logout`
- `GET /api/auth/me` — requires auth
- `PATCH /api/auth/me` — update profile (`firstName`, `lastName`, `email`, `phone`) — requires auth
- `GET /api/appointments?filter=upcoming|past|all` — requires auth
- `GET /api/appointments/:id` — requires auth
- `POST /api/appointments/request` — public book form

## HIPAA note

MVP stores scheduling metadata only (name, phone, appointment details). Full HIPAA compliance (BAA, audit logs, encryption policies) is a later phase.
