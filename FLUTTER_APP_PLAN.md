# OrthoExpress Flutter Mobile App — Master Plan

> Source: React/Vite web app (`src/`, `public/assets/`).  
> Goal: Native mobile app with design parity, shop flow, bilingual EN/ES, and clinic content.

---

## 1. App Overview

**OrthoExpress** is an orthopedic walk-in clinic application with:

- Clinical information (services, locations, patient care)
- Appointment booking & contact forms
- Ortho Shop (9 products, cart, checkout, orders)
- Blogs, news, FAQs
- Bilingual English / Spanish
- Demo payment mode (Stripe-ready on web)

**Headquarters:** Midland, TX — `(432) 322-8675`  
**Locations in data:** Los Angeles, London, Berlin (3 detail pages)

---

## 2. Design System

### 2.1 Colors

| Token | Hex | Flutter usage |
|--------|-----|----------------|
| Primary | `#1A237E` | App bar, nav active, headings accent |
| Primary dark | `#0D1B6B` | Pressed states |
| Primary soft | `#E8EAF6` | Chips, backgrounds |
| Accent (CTA) | `#00A86B` | Primary buttons, FAB |
| Accent hover | `#008F5A` | Button pressed |
| Accent pink | `#E91E63` | Optional highlights |
| Text dark | `#1E293B` | Body text |
| Text light | `#64748B` | Secondary text |
| Text muted | `#94A3B8` | Captions |
| BG light | `#F4F6FB` | Screen backgrounds |
| BG white | `#FFFFFF` | Cards |
| BG soft | `#EEF1F8` | Sections |
| Border | `#E2E8F0` | Dividers, inputs |

**Gradients (web):**

- Primary button: `#00A86B` → `#00C07A`
- Secondary button: `#1A237E` → `#283593`

**Theme color (meta):** `#1A237E`

### 2.2 Typography

| Role | Web font | Flutter equivalent |
|------|----------|-------------------|
| UI / body | Manrope (400–800) | `GoogleFonts.manrope()` |
| Display / titles | Source Serif 4 (500–700) | `GoogleFonts.sourceSerif4()` |

**Sizes (mobile):**

- Hero title: 28–32sp (Serif)
- Page title: 24–28sp (Serif)
- Section title: 20–22sp
- Body: 16sp, line height ~1.65
- Small / caption: 13–14sp

### 2.3 Spacing & Shape

- Screen padding: 18–24dp
- Section padding: 48–64dp vertical (mobile)
- Radius: 8 / 12 / 16 / 24dp
- Card shadow: soft elevation 2–4
- Button padding: ~13×28dp

### 2.4 Buttons

1. **Primary** — green gradient, white text, shadow
2. **Secondary** — navy gradient
3. **Outline** — navy border, fill on press

---

## 3. Navigation Architecture

### 3.1 Structure

```
AppShell
├── BottomNavigationBar (5 tabs)
│   ├── Home
│   ├── Services
│   ├── Shop
│   ├── Locations
│   └── More
├── AppBar (contextual title, search, cart badge, language toggle)
└── Quick actions: Call | Book (sticky bar or FAB pair)
```

### 3.2 Bottom Bar (5 tabs)

| Tab | Icon | Primary screen | Badge |
|-----|------|----------------|-------|
| Home | `home` | Home dashboard | — |
| Services | `medical_services` | Services list | — |
| Shop | `shopping_bag` | Shop grid | Cart count |
| Locations | `location_on` | Locations list | — |
| More | `menu` | More / hub screen | — |

**Active color:** `#1A237E`  
**Inactive:** `#64748B`

### 3.3 Routes (`go_router`)

```
/home
/services
/services/:slug
/locations
/locations/:slug
/shop
/cart
/checkout
/orders
/order-success/:id
/order-failure
/about
/workers-comp
/blogs
/blogs/:slug
/book-appointment
/contact-us
/payment
/telehealth
/after-your-visit
/patient-portal
/technology
/faqs
/careers
/news
/privacy-policy
/terms
/accessibility
/search
```

### 3.4 “More” Screen Sections

- **Patient care:** Telehealth, After Visit, Patient Portal, Technology
- **Company:** About, Workers Comp, Careers, News
- **Resources:** Blogs, FAQs, Payment & Insurance
- **Legal:** Privacy, Terms, Accessibility
- **Contact:** Contact Us, Book Appointment

### 3.5 Deep Linking

Map web URLs 1:1 for marketing:

- `orthoexpress.com/shop` → `/shop`
- `orthoexpress.com/services/arthritis` → `/services/arthritis`

### 3.6 Search

Full-screen search indexing services, locations, blogs, news, key pages (max 8 results). Mirrors `SiteSearch.jsx`.

---

## 4. Page-by-Page Specification

### 4.1 Home (`Home.jsx` — 9 sections)

| Section | Web component | Flutter widget |
|---------|---------------|----------------|
| Hero | Full-bleed image + overlay + 3 CTAs | `Stack` + `Image` + gradient + buttons |
| What We Treat | Condition chips/cards | Horizontal scroll or grid |
| Services Snapshot | 3 cards (injured / sports / workers) | `PageView` or row cards with images |
| Clinic Services | Icon grid | `GridView` |
| Locations Preview | 3 location cards | Horizontal `ListView` |
| Treatment Areas | Body-area links | Chip grid → service routes |
| Reviews Bar | Google rating strip | Rating bar + link to Maps |
| Testimonials | Carousel | `CarouselSlider` |
| Stats | Counters | Animated stat row |
| Insurance Bar | Provider logos | Logo row |
| Blog Preview | 3 blog cards | Horizontal cards |

**Hero image:** `assets/images/home/hero.jpg`  
**CTAs:** Book Appointment, Find Center, Call (`tel:`)

### 4.2 Services

| Screen | Content |
|--------|---------|
| **Services list** | Primary 8 + specialty 6 + Workers Comp card |
| **Service detail** | Hero image, title, description, sections, related links |

**15 service slugs** (+ workers-comp page):

- Primary: `pain-inflammation`, `injuries-fractures-sprains`, `arthritis`, `casting-splinting`, `sports-medicine`, `mri-digital-imaging`, `prp-orthobiologics`, `pediatric-care`
- Specialty: `hand-wrist-care`, `shoulder-elbow`, `lumbar-cervical-spine`, `hip-knee-care`, `foot-ankle-care`, `total-joint-replacement`

Images from `public/assets/services/` via `images.js` map.

### 4.3 Locations

| Screen | Content |
|--------|---------|
| **List** | 3 cards: image, name, city, phone, features |
| **Detail** | Hero, descriptions, specialties, services list, features, hours, Open in Maps, Call |

**Native:** `url_launcher` for Maps and `tel:`

### 4.4 Shop Flow

| Screen | Features |
|--------|----------|
| **Shop** | Hero, category pills, product grid |
| **Product card** | Image, name, price, Add to Cart, info tooltip |
| **Cart** | Line items, qty +/-, remove, summary |
| **Checkout** | Shipping form + payment (demo or Stripe) |
| **Order success** | Order ID, summary |
| **Order failure** | Error message, retry |
| **Orders** | Local history list |

**Totals (from `checkout.js`):**

- Shipping: `$5.99` when subtotal > 0
- Tax: `8%` of subtotal

**9 products:**

| Product | Price | Category | Image |
|---------|-------|----------|-------|
| CBD Lotion 1000mg | $80.24 | cbd-wellness | `cbd-lotion.jpg` |
| CBD Freeze Roll-On | $74.89 | cbd-wellness | `cbd-rollon.jpg` |
| CBD Tincture 500mg | $58.83 | cbd-wellness | `cbd-tincture.webp` |
| Cold Therapy Gel Pack | $24.99 | pain-relief | `cold-pack.webp` |
| Knee Stabilizer Brace | $49.99 | braces-supports | `knee-brace.jpg` |
| Wrist Splint | $34.99 | braces-supports | `wrist-splint.jpg` |
| Ankle Support Brace | $39.99 | braces-supports | `ankle-brace.webp` |
| Compression Ice Wrap | $29.99 | pain-relief | `ice-wrap.jpg` |
| Arm Sling with Pocket | $27.99 | braces-supports | `arm-sling.webp` |

**Cart persistence keys:**

- `orthoexpress_cart`
- `orthoexpress_orders`

### 4.5 Forms

| Form | Fields | Notes |
|------|--------|-------|
| **Book Appointment** | name, email, phone, date, time, reason, location, consent | Modal success/error |
| **Contact Us** | name, email, phone, message | Same pattern |
| **Checkout** | shipping + payment | Navigate to success/failure |

Validation mirrors `checkout.js` / `forms.js`.

### 4.6 Info / Content Pages

Shared layout: eyebrow, title, lead, blocks, card grids, CTAs.

| Page | Data source |
|------|-------------|
| About | `about` images, team, facility |
| Workers Comp | `workers-comp/hero.jpg` |
| Payment | `INSURANCE_PROVIDERS`, `SELF_PAY_PRICING` |
| Telehealth | `TELEHEALTH_WHEN`, `TELEHEALTH_STEPS` |
| After Visit | `AFTER_VISIT_STEPS` |
| Patient Portal | `PORTAL_FEATURES`; external URL if configured |
| Technology | `TECHNOLOGY_FEATURES`, `ORTHOCHAT_FEATURES` |
| FAQs | `FAQS` accordion |
| Careers | `CAREERS` |
| News | `NEWS_ITEMS` |
| Privacy / Terms / Accessibility | i18n legal text |

### 4.7 Blogs

- **List:** 6 posts with image, category, date, excerpt
- **Detail:** Full content (EN + ES in `blogContentEs.js`)

**Slugs:** `understanding-orthopedic-injuries`, `recovery-after-surgery`, `sports-injury-prevention`, `managing-chronic-pain`, `exercise-for-joint-health`, `when-to-see-orthopedic-specialist`

### 4.8 Not Found

Friendly 404 with Home link.

---

## 5. Global UI Components

| Web component | Flutter equivalent |
|---------------|-------------------|
| `Header` | `AppBar` + optional top info strip |
| `Footer` | More screen + legal links |
| `MobileActionBar` | Bottom sticky bar (Call / Book) |
| `LanguageToggle` | EN \| ES in AppBar |
| `SiteSearch` | Search delegate / full-screen |
| `PageHeroMedia` | Hero `Stack` with image + gradient |
| `PageBodyMedia` | `ClipRRect` + `Image.asset` |
| `ImageWithFallback` | `Image.asset` + `errorBuilder` |
| `Modal` | `showDialog` / bottom sheet |
| `FormFeedback` | Snackbar / dialog |
| `ProductCard` | `Card` + `InkWell` |
| `ProductInfoTooltip` | Bottom sheet |
| `AccessibilityToolbar` | Settings or floating a11y panel |
| `ErrorBoundary` | Flutter error widget |

---

## 6. State Management & Data

### 6.1 Stack

| Layer | Package |
|-------|---------|
| Routing | `go_router` |
| State | `provider` or `riverpod` |
| Local storage | `shared_preferences` (cart, orders, lang, a11y) |
| i18n | `flutter_localizations` + ARB |
| Images | `assets/images/` |
| Network (later) | `dio` for forms API, Stripe |
| Fonts | `google_fonts` |
| URLs | `url_launcher` |

### 6.2 Data Models

```
Clinic, Location, Service, ServiceDetail, Blog, Product, CartItem, Order,
Customer, OrderTotals, FAQ, NewsItem, Career, InsuranceProvider
```

### 6.3 Web Data Sources to Port

- `src/data/clinic.js`
- `src/data/locations.js`
- `src/data/services.js`
- `src/data/serviceDetails.js`
- `src/data/products.js`
- `src/data/blogs.js`
- `src/data/content.js`
- `src/data/patientCare.js`
- `src/data/images.js`
- `src/i18n/translations.js` (+ domain files)

---

## 7. Images & Assets

Copy `public/assets/` → `flutter_app/assets/images/`:

```
assets/images/
├── home/
├── about/
├── services/
├── blogs/
├── shop/
├── workers-comp/
├── los-angeles.avif, london.jpg, berlin.webp, knee-injury.webp, etc.
```

**Image handling:**

- Hero: `BoxFit.cover`, dark gradient overlay
- Product wearable: center crop
- Product bottle/packshot: `BoxFit.contain` on soft background
- AVIF: use as-is or convert if needed

**App icon / splash:** Primary `#1A237E`, logo “OrthoExpress”, accent green CTA.

---

## 8. Features to Port

| Feature | Web | Flutter |
|---------|-----|---------|
| EN / ES | `LanguageContext` | ARB + `LocaleProvider` |
| Cart persistence | `localStorage` | `shared_preferences` |
| Orders history | `localStorage` | `shared_preferences` |
| Demo payment | `processCheckoutPayment` | Local validation + fake delay |
| Stripe (future) | `VITE_STRIPE_*` | `flutter_stripe` + env |
| Patient portal | External URL | `url_launcher` |
| Google Maps | `getMapsDirectionsUrl` | `url_launcher` |
| Phone / email | `tel:`, `mailto:` | `url_launcher` |
| Accessibility | Font scale, contrast | Theme variants |
| Product stats | `useProductStats` | Local mock units sold |
| Reviews | Google widget | Link to Maps URL |

---

## 9. Mobile-Specific UX

1. Pull-to-refresh on lists
2. Haptic feedback on Add to Cart
3. Safe area for bottom nav + call/book bar
4. Offline: cache images; cached content when offline
5. Share: location, blog, service via `share_plus`
6. Biometric (optional later) for orders / portal
7. Push notifications (optional): appointment reminders
8. No horizontal scroll on main content

---

## 10. Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── theme.dart
│   │   ├── routes.dart
│   │   └── env.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   └── widgets/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── local/
│   ├── l10n/
│   ├── providers/
│   └── features/
│       ├── home/
│       ├── services/
│       ├── locations/
│       ├── shop/
│       ├── blogs/
│       ├── appointment/
│       ├── contact/
│       ├── more/
│       └── search/
├── assets/images/
└── pubspec.yaml
```

---

## 11. Implementation Phases

| Phase | Scope | Deliverable | Status |
|-------|--------|-------------|--------|
| **1 — Foundation** | Theme, routing, bottom nav, assets, i18n shell | Navigable shell with 5 tabs | **Done** |
| **2 — Core content** | Home, Services, Locations, About | Clinical browsing | **Done** |
| **3 — Shop** | Products, cart, checkout demo, orders | Full shop loop | **Done** |
| **4 — Forms** | Appointment, contact | Validated forms + Formspree | **Done** |
| **5 — Content** | Blogs, FAQs, news, patient pages, legal | Content parity | **Done** |
| **6 — Polish** | Search, a11y, animations, maps/call links | Production polish | **Partial** (search + call/maps links) |
| **7 — Backend** | Real form API, Stripe, patient portal | Live integrations | **Partial** (Formspree via `.env`) |

### Phase 1 scaffold (started)

- Project: `flutter_app/` (`orthoexpress_app`)
- Theme, colors, Manrope + Source Serif 4 via `google_fonts`
- `go_router` + adaptive navigation:
  - **Phones (<768px):** bottom nav + Call/Book bar
  - **Tablets (≥768px):** side `NavigationRail` + Call/Book in app bar
- Responsive layout system (`responsive.dart`, `ResponsivePage`, `ResponsiveCardGrid`)
- Text scaling clamped 0.9–1.25 for accessibility without layout breaks
- Data: clinic, products, locations, services
- Cart provider with `shared_preferences`
- Language toggle shell (EN/ES locale, full i18n ARB files pending)
- Assets copied from `public/assets/`
- Screens: Home, Services (+ detail), Shop, Cart, Locations (+ detail), More
- Automated responsive tests for 320px–1280px viewports
- Placeholder routes for remaining pages

---

## 12. Parity Checklist

- [ ] Home
- [ ] About
- [ ] Workers Comp
- [ ] Locations list + 3 details
- [ ] Services list + 15 details + workers comp
- [ ] Shop, Cart, Checkout, Order Success, Order Failure, Orders
- [ ] Blogs list + 6 details
- [ ] Book Appointment
- [ ] Contact Us
- [ ] Payment
- [ ] Telehealth, After Visit, Patient Portal, Technology
- [ ] FAQs, Careers, News
- [ ] Privacy, Terms, Accessibility
- [ ] Search
- [ ] Not Found
- [ ] Language toggle EN/ES
- [ ] Call + Book quick actions

---

## 13. Clinic Constants (Quick Reference)

```dart
// From clinic.js
name: 'OrthoExpress'
email: 'info@orthoexpress.com'
headquarters.phone: '(432) 322-8675'
headquarters.fax: '(432) 218-7726'
hours: 'Monday – Friday: 9:00 AM – 5:00 PM'
googleReviews.rating: 4.8
googleReviews.count: 240
```

---

*Last updated: planning session — Flutter scaffold in `flutter_app/`.*
