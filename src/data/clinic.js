/** Site-wide clinic brand and primary contact — single source of truth */
export const CLINIC = {
  name: 'OrthoExpress',
  tagline: 'Orthopedic Walk-In Clinic and #Teleorthopedics.',
  email: 'info@orthoexpress.com',
  headquarters: {
    label: 'Midland',
    city: 'Midland, TX',
    phone: '(432) 322-8675',
    fax: '(432) 218-7726',
  },
  social: {
    facebook: 'https://www.facebook.com/',
    twitter: 'https://twitter.com/',
    linkedin: 'https://www.linkedin.com/',
    instagram: 'https://www.instagram.com/',
  },
  googleReviews: {
    rating: 4.8,
    count: 240,
    mapsUrl:
      import.meta.env.VITE_GOOGLE_REVIEWS_URL ||
      'https://www.google.com/maps/search/?api=1&query=OrthoExpress+Midland+TX',
  },
  hours: {
    weekday: 'Monday – Friday: 9:00 AM – 5:00 PM',
    short: 'Mon – Fri: 9 am – 5 pm',
  },
}
