# OrthoExpress Flutter App

Mobile app for OrthoExpress — mirrors the React web app.

## Plan

See [../FLUTTER_APP_PLAN.md](../FLUTTER_APP_PLAN.md) for the full specification.

## Run

```bash
cd flutter_app
flutter pub get
flutter run
```

## Current status (Phase 1)

- **Adaptive navigation**
  - Phones (&lt;768px): bottom bar + Call/Book quick actions
  - Tablets (≥768px): side navigation rail + Call/Book in app bar
- Theme matching web (navy + green, Manrope + Source Serif 4)
- Responsive layouts for phones (320px+) and tablets (768px–1280px+)
- Shop grid auto-columns via `maxCrossAxisExtent`
- Cart with side summary on tablet
- Service and location detail screens
- EN/ES locale toggle (full translations pending)
- Responsive regression tests in `test/responsive_layout_test.dart`
- Placeholder screens for checkout, forms, blogs, legal pages

## Next steps

1. Phase 3: Checkout, orders, order success/failure
2. Phase 4: Book appointment + contact forms
3. Phase 5: Blogs, FAQs, patient care pages, legal content
4. Phase 6: Search, accessibility toolbar, polish
