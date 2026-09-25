## 2026-09-13 - Icon-Only External Link Buttons
**Learning:** External documentation icon buttons wrapped inside anchor elements (`<a><Button size="icon"><ExternalLink /></Button></a>`) often pass tooltip titles to the anchor tag while leaving the internal `<button>` element without an explicit accessible name (`aria-label`), causing screen readers to announce an unlabelled button.
**Action:** Always add explicit `aria-label` directly to icon-only `<Button>` instances even when wrapped in titled anchor elements or parent containers.

## 2026-09-14 - Popover Toggle ARIA Attributes and Localized Modal Controls
**Learning:** Custom dropdown/popover toggle buttons (e.g. `UseAsMenu`) often omit `aria-expanded` and `aria-haspopup="menu"`, leaving screen readers unable to convey whether popover menus are active. Additionally, modal close buttons can fall back to hardcoded English `"Close"` rather than localized translation strings (`t.common.close`).
**Action:** Always include `aria-expanded={open}` and `aria-haspopup="menu"` on popover triggers, and use `aria-label={t.common.close}` for modal close controls across all supported locales.

## 2026-09-15 - Sortable Table Headers Accessibility
**Learning:** Table header cells with `onClick` sort handlers (`<th onClick={...}>`) are not focusable or interactive for keyboard users (`Tab`/`Enter`) and lack screen reader state (`aria-sort`).
**Action:** Always wrap sortable column header text in a `<button type="button">` with focus-visible ring styles and add `scope="col"` and `aria-sort` (`"ascending"`, `"descending"`, or `"none"`) to the parent `<th>` element.

## 2026-09-16 - Confirm Dialog Loading Feedback and Dismissal Guarding
**Learning:** Async confirm dialogs (e.g. destructive delete operations) often lack animated visual feedback (`Spinner`) and screen reader state (`aria-busy`), and can be accidentally cancelled mid-request via Escape or backdrop click.
**Action:** Always attach `aria-busy={loading}` and `<Spinner />` to action buttons during pending operations, and guard backdrop clicks and Escape key handlers with `!loading`.

## 2026-09-17 - Dialog Trigger ARIA Attributes
**Learning:** Dialog trigger buttons that open modal or popover dialogs (e.g., model picker in ChatSidebar) often omit `aria-haspopup="dialog"` and `aria-expanded`, preventing screen reader users from realizing an interactive button opens a modal dialog context.
**Action:** Always include `aria-haspopup="dialog"` and `aria-expanded={open}` on buttons that trigger dialog overlays.

## 2026-09-18 - Keyboard Focus Visible Styles on Custom Link Buttons
**Learning:** Custom styled anchor elements used as page header actions (e.g., `DS_BUTTON_OUTLINED_LINK_CN` in `DocsPage.tsx`) can omit `focus-visible` focus ring styles, leaving keyboard (`Tab`) navigation without visual focus feedback.
**Action:** Always include `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2` on custom styled link button components.
