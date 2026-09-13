## 2026-09-13 - Icon-Only External Link Buttons
**Learning:** External documentation icon buttons wrapped inside anchor elements (`<a><Button size="icon"><ExternalLink /></Button></a>`) often pass tooltip titles to the anchor tag while leaving the internal `<button>` element without an explicit accessible name (`aria-label`), causing screen readers to announce an unlabelled button.
**Action:** Always add explicit `aria-label` directly to icon-only `<Button>` instances even when wrapped in titled anchor elements or parent containers.
