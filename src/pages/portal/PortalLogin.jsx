import React, { useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import PageMeta from '../../components/PageMeta'
import { useLanguage } from '../../context/LanguageContext'
import { useAuth } from '../../context/AuthContext'
import { authApi } from '../../api/client'
import './Portal.css'

function formatPhoneInput(value) {
  const digits = value.replace(/\D/g, '').slice(0, 10)
  if (digits.length <= 3) return digits
  if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`
  return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6)}`
}

const PortalLogin = () => {
  const { t } = useLanguage()
  const { login, isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const from = location.state?.from || '/portal'

  const [step, setStep] = useState('phone')
  const [phone, setPhone] = useState('')
  const [code, setCode] = useState(['', '', '', '', '', ''])
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [resendCooldown, setResendCooldown] = useState(0)
  const otpRefs = useRef([])

  useEffect(() => {
    if (isAuthenticated) navigate(from, { replace: true })
  }, [isAuthenticated, navigate, from])

  useEffect(() => {
    if (resendCooldown <= 0) return undefined
    const timer = setTimeout(() => setResendCooldown((s) => s - 1), 1000)
    return () => clearTimeout(timer)
  }, [resendCooldown])

  const phoneDigits = phone.replace(/\D/g, '')
  const isPhoneValid = phoneDigits.length === 10

  const handleSendCode = async (e) => {
    e?.preventDefault()
    if (!isPhoneValid) {
      setError(t('portal.login.invalidPhone'))
      return
    }
    setError('')
    setLoading(true)
    try {
      await authApi.requestOtp(phone)
      setStep('code')
      setResendCooldown(30)
      setTimeout(() => otpRefs.current[0]?.focus(), 100)
    } catch (err) {
      setError(err.message || t('portal.errors.generic'))
    } finally {
      setLoading(false)
    }
  }

  const handleOtpChange = (index, value) => {
    const digit = value.replace(/\D/g, '').slice(-1)
    const next = [...code]
    next[index] = digit
    setCode(next)
    if (digit && index < 5) otpRefs.current[index + 1]?.focus()
  }

  const handleOtpKeyDown = (index, e) => {
    if (e.key === 'Backspace' && !code[index] && index > 0) {
      otpRefs.current[index - 1]?.focus()
    }
  }

  const handleVerify = async (e) => {
    e.preventDefault()
    const fullCode = code.join('')
    if (fullCode.length !== 6) {
      setError(t('portal.login.invalidCode'))
      return
    }
    setError('')
    setLoading(true)
    try {
      await login(phone, fullCode)
      navigate(from, { replace: true })
    } catch (err) {
      setError(err.message || t('portal.errors.generic'))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="portal-page">
      <PageMeta title={t('portal.login.title')} description={t('portal.login.subtitle')} />

      <section className="portal-hero">
        <div className="container">
          <h1 className="page-title">{t('portal.login.title')}</h1>
          <p className="page-subtitle">{t('portal.login.subtitle')}</p>
        </div>
      </section>

      <div className="container">
        <div className="portal-card">
          {step === 'phone' ? (
            <form onSubmit={handleSendCode}>
              <h2>{t('portal.login.phoneLabel')}</h2>
              <p>{t('portal.login.phoneHelp')}</p>
              <div className="portal-field">
                <label htmlFor="portal-phone">{t('portal.login.phoneLabel')}</label>
                <input
                  id="portal-phone"
                  type="tel"
                  inputMode="tel"
                  autoComplete="tel"
                  placeholder={t('portal.login.phonePlaceholder')}
                  value={phone}
                  onChange={(e) => setPhone(formatPhoneInput(e.target.value))}
                />
              </div>
              {error && <p className="portal-error" role="alert">{error}</p>}
              <button type="submit" className="btn btn-primary btn-large" disabled={loading || !isPhoneValid}>
                {loading ? t('portal.login.sending') : t('portal.login.sendCode')}
              </button>
            </form>
          ) : (
            <form onSubmit={handleVerify}>
              <h2>{t('portal.login.verifyTitle')}</h2>
              <p>
                {t('portal.login.verifySubtitle').replace('{phone}', phone)}
              </p>
              <div className="portal-otp-inputs" role="group" aria-label={t('portal.login.codeLabel')}>
                {code.map((digit, i) => (
                  <input
                    key={i}
                    ref={(el) => { otpRefs.current[i] = el }}
                    type="text"
                    inputMode="numeric"
                    maxLength={1}
                    value={digit}
                    onChange={(e) => handleOtpChange(i, e.target.value)}
                    onKeyDown={(e) => handleOtpKeyDown(i, e)}
                    aria-label={`Digit ${i + 1}`}
                  />
                ))}
              </div>
              {error && <p className="portal-error" role="alert">{error}</p>}
              <button type="submit" className="btn btn-primary btn-large" disabled={loading}>
                {loading ? t('portal.login.verifying') : t('portal.login.verify')}
              </button>
              <div className="portal-actions-row">
                <button type="button" className="portal-link-btn" onClick={() => { setStep('phone'); setCode(['','','','','','']); setError('') }}>
                  {t('portal.login.changeNumber')}
                </button>
                <button
                  type="button"
                  className="portal-link-btn"
                  disabled={resendCooldown > 0 || loading}
                  onClick={handleSendCode}
                >
                  {resendCooldown > 0
                    ? t('portal.login.resendIn').replace('{seconds}', resendCooldown)
                    : t('portal.login.resend')}
                </button>
              </div>
            </form>
          )}
        </div>

        <p style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <Link to="/patient-portal">← {t('nav.patientPortal')}</Link>
        </p>
      </div>
    </div>
  )
}

export default PortalLogin
