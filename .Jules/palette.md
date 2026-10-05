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

## 2026-09-19 - Label Association for Interactive Switch Controls
**Learning:** `Switch` toggle controls paired with text using standard `<span>` tags or `<Label>` elements without explicit `id`/`htmlFor` bindings leave the text non-interactive when clicked and break semantic control binding for assistive technology.
**Action:** Always connect `Switch` controls to their label text using matching `id` and `htmlFor` attributes, and include `cursor-pointer` on the label element to make clicking label text toggle the switch.

## 2026-09-20 - Popover Menu Escape Key Dismissal and ARIA Menu Semantics
**Learning:** Custom popover menus (such as model assignment menus) that open on button clicks often handle outside pointer clicks but omit `Escape` key listeners and ARIA menu roles (`role="menu"`, `role="menuitem"`), preventing keyboard users from dismissing the menu and screen readers from identifying menu items.
**Action:** Always add a `keydown` event listener for `Escape` to close open popover menus, and apply `role="menu"`, `role="menuitem"`, and `role="presentation"` attributes to popover containers and items.

## 2026-09-21 - Modal Portal Layering and Escape Key Dismissal
**Learning:** OAuth and authentication modal dialogs rendered inside nested dashboard containers can be trapped in lower z-index stacking contexts below sidebar overlays, and omit `Escape` key listeners required by keyboard users to dismiss/cancel pending flows.
**Action:** Always render top-level modal overlays using `createPortal(..., document.body)` and add a `keydown` event listener for `Escape` key dismissal.

## 2026-09-22 - Keyboard Focus and ARIA Semantics on Expandable List Rows
**Learning:** Clickable container elements used for expandable list items (e.g. `SessionRow` in `SessionsPage.tsx`) often use `onClick` without `role="button"`, `tabIndex={0}`, `aria-expanded`, or `onKeyDown` listeners, trapping keyboard users who cannot focus or toggle row details using `Tab` and `Enter`/`Space`.
**Action:** Always convert interactive list item row headers into accessible button controls with `role="button"`, `tabIndex={0}`, `aria-expanded`, dynamic `aria-label`, `focus-visible` ring styles, and an `onKeyDown` listener handling `Enter` and `Space`.

## 2026-09-23 - External Link Target ARIA Announcements
**Learning:** External links configured with `target="_blank"` without explicit screen reader cues leave visually impaired users unaware that activating the link opens a new tab or window.
**Action:** Always provide an explicit `aria-label` stating that activating the external link opens in a new tab (e.g., `aria-label={`${title} (opens in new tab)`}`).
