/**
 * Escape HTML entities so user/source content cannot inject script tags when used with v-html.
 */
function escapeHtml(s: string): string {
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  }
  return s.replace(/[&<>"']/g, (ch) => map[ch] ?? ch)
}

/**
 * Wraps each occurrence of search text in a string with a <mark> tag for highlighting.
 * Escapes HTML in the source text to prevent XSS when the result is used with v-html.
 */
export function highlightSearch(text: string, search: string): string {
  if (!text) return ''
  const safeText = escapeHtml(String(text))
  if (!search?.trim()) return safeText
  const escaped = search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  const re = new RegExp(`(${escaped})`, 'gi')
  return safeText.replace(re, '<mark class="hpa-search-highlight">$1</mark>')
}
