# Orthoexpress - Orthopedic Walk-in Clinic Website

A modern, responsive React.js website for Orthoexpress, an orthopedic walk-in clinic providing comprehensive orthopedic care services.

## Features

- **Home Page** with hero section, services overview, testimonials, stats, insurance info, and blog previews
- **About Us** page with clinic mission, vision, and story
- **Services Pages** for individual orthopedic services:
  - Hand & Wrist Care
  - Shoulder & Elbow
  - Lumbar & Cervical Spine
  - Hip & Knee Care
  - Foot & Ankle Care
  - Total Joint Replacement
  - Auto Injury
  - Sports Medicine
- **Workers' Compensation** information page
- **Locations** page with clinic locations and contact info
- **Blogs** listing and detail pages
- **Contact Us** page with contact form
- **Book Appointment** page with appointment request form

## Tech Stack

- React 18
- React Router DOM 6
- Vite (build tool)
- React Icons
- CSS3 (with CSS Variables for theming)

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn

### Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

3. Open your browser and navigate to `http://localhost:3000`

### Build for Production

```bash
npm run build
```

The built files will be in the `dist` directory.

### Preview Production Build

```bash
npm run preview
```

## Project Structure

```
orthoexpress/
├── src/
│   ├── components/
│   │   ├── Header.jsx          # Navigation header component
│   │   ├── Footer.jsx          # Footer component
│   │   └── home/               # Home page components
│   │       ├── Hero.jsx
│   │       ├── ServicesSnapshot.jsx
│   │       ├── ClinicServices.jsx
│   │       ├── LocationsPreview.jsx
│   │       ├── Testimonials.jsx
│   │       ├── Stats.jsx
│   │       ├── InsuranceBar.jsx
│   │       └── BlogPreview.jsx
│   ├── pages/
│   │   ├── Home.jsx
│   │   ├── About.jsx
│   │   ├── WorkersComp.jsx
│   │   ├── Locations.jsx
│   │   ├── Blogs.jsx
│   │   ├── BlogDetail.jsx
│   │   ├── ContactUs.jsx
│   │   ├── BookAppointment.jsx
│   │   └── ServiceDetail.jsx
│   ├── App.jsx                 # Main app component with routing
│   ├── main.jsx                # Entry point
│   └── index.css               # Global styles
├── docs/
│   └── plan.md                 # Project plan and documentation
├── package.json
├── vite.config.js
└── index.html
```

## Color Scheme

- Primary Color: `#0066cc` (Blue)
- Accent Color: `#00a86b` (Green)
- Text Dark: `#2c3e50`
- Text Light: `#6c757d`
- Background Light: `#f8f9fa`

## Features Implemented

✅ Responsive design for mobile, tablet, and desktop
✅ Sticky header navigation
✅ Services dropdown menu
✅ Testimonials slider with auto-rotation
✅ Contact and appointment forms
✅ All routes and pages as per plan
✅ Professional medical theme
✅ Clean, modern UI

## Next Steps

To customize the website:

1. **Replace placeholder images**: Add actual images to replace the placeholder divs
2. **Update content**: Modify text content in components to match your specific needs
3. **Add real data**: Connect forms to backend services or email services
4. **SEO optimization**: Add meta tags, structured data, and optimize for search engines
5. **Analytics**: Add Google Analytics or similar tracking
6. **Images**: Replace placeholder divs with actual medical images

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## License

This project is created for Orthoexpress clinic.

