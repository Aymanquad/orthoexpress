import express from 'express'
import cors from 'cors'
import cookieParser from 'cookie-parser'
import { env } from './config/env.js'
import authRoutes from './routes/auth.routes.js'
import appointmentsRoutes from './routes/appointments.routes.js'
import ordersRoutes from './routes/orders.routes.js'
import workplaceAuthRoutes from './routes/workplaceAuth.routes.js'
import workplaceStaffRoutes from './routes/workplaceStaff.routes.js'
import workplaceAppointmentsRoutes from './routes/workplaceAppointments.routes.js'
import workplaceOrdersRoutes from './routes/workplaceOrders.routes.js'
import workplacePrescriptionsRoutes from './routes/workplacePrescriptions.routes.js'
import workplaceDemographicsRoutes from './routes/workplaceDemographics.routes.js'
import workplacePatientsRoutes from './routes/workplacePatients.routes.js'
import recordsRoutes from './routes/records.routes.js'

const app = express()

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true)
      const allowed =
        origin === env.CLIENT_ORIGIN ||
        origin.startsWith('http://localhost:') ||
        origin.startsWith('http://127.0.0.1:')
      callback(allowed ? null : new Error('Not allowed by CORS'), allowed)
    },
    credentials: true,
  })
)
app.use(express.json())
app.use(cookieParser())

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok' })
})

app.use('/api/auth', authRoutes)
app.use('/api/appointments', appointmentsRoutes)
app.use('/api/orders', ordersRoutes)
app.use('/api/workplace/auth', workplaceAuthRoutes)
app.use('/api/workplace/staff', workplaceStaffRoutes)
app.use('/api/workplace/appointments', workplaceAppointmentsRoutes)
app.use('/api/workplace/orders', workplaceOrdersRoutes)
app.use('/api/workplace/prescriptions', workplacePrescriptionsRoutes)
app.use('/api/workplace/demographics', workplaceDemographicsRoutes)
app.use('/api/workplace/patients', workplacePatientsRoutes)
app.use('/api/records', recordsRoutes)

app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(err)
  res.status(500).json({ error: 'Internal server error' })
})

app.listen(env.PORT, () => {
  console.log(`API running on http://localhost:${env.PORT}`)
})
