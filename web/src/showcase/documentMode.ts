import { useSyncExternalStore } from 'react'

function subscribeToDocument(onChange: () => void) {
  const observer = new MutationObserver(onChange)
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme', 'data-density'] })
  return () => observer.disconnect()
}

/**
 * The current `data-theme` and `data-density`. Pages that print resolved token values read them during
 * render, so they subscribe to these attributes to re-render after the theme or density changes.
 */
export function useDocumentMode() {
  const snapshot = useSyncExternalStore(subscribeToDocument, () => {
    const { theme = 'light', density = 'default' } = document.documentElement.dataset
    return `${theme}|${density}`
  })
  const [theme, density] = snapshot.split('|')
  return { theme, density }
}

/** Resolved value of a CSS variable on `<html>`, for example `cssVar('--spacing-sm')` is `8px`. */
export function cssVar(name: string) {
  return getComputedStyle(document.documentElement).getPropertyValue(name).trim()
}
