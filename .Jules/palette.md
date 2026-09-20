## 2026-09-13 - Icon-Only External Link Buttons
**Learning:** External documentation icon buttons wrapped inside anchor elements (`<a><Button size="icon"><ExternalLink /></Button></a>`) often pass tooltip titles to the anchor tag while leaving the internal `<button>` element without an explicit accessible name (`aria-label`), causing screen readers to announce an unlabelled button.
**Action:** Always add explicit `aria-label` directly to icon-only `<Button>` instances even when wrapped in titled anchor elements or parent containers.

## 2026-09-14 - Popover Toggle ARIA Attributes and Localized Modal Controls
**Learning:** Custom dropdown/popover toggle buttons (e.g. `UseAsMenu`) often omit `aria-expanded` and `aria-haspopup="menu"`, leaving screen readers unable to convey whether popover menus are active. Additionally, modal close buttons can fall back to hardcoded English `"Close"` rather than localized translation strings (`t.common.close`).
**Action:** Always include `aria-expanded={open}` and `aria-haspopup="menu"` on popover triggers, and use `aria-label={t.common.close}` for modal close controls across all supported locales.
