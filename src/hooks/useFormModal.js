import { useState, useCallback } from 'react'

const initialModal = {
  isOpen: false,
  type: 'info',
  title: '',
  message: '',
}

export function useFormModal() {
  const [modal, setModal] = useState(initialModal)

  const closeModal = useCallback(() => {
    setModal(initialModal)
  }, [])

  const showSuccess = useCallback((title, message) => {
    setModal({ isOpen: true, type: 'success', title, message })
  }, [])

  const showError = useCallback((title, message) => {
    setModal({ isOpen: true, type: 'error', title, message })
  }, [])

  const showValidationErrors = useCallback((errors, title) => {
    const messages = Object.values(errors)
    setModal({
      isOpen: true,
      type: 'warning',
      title,
      message: messages,
      isValidationList: true,
    })
  }, [])

  return { modal, closeModal, showSuccess, showError, showValidationErrors }
}
