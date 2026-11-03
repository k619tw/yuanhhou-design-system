import { useSyncExternalStore } from 'react'

// Hash routes (`#/button`) so the demo needs no router and works from any static host.
// Back and forward use the browser history.

function subscribe(onChange: () => void) {
  window.addEventListener('hashchange', onChange)
  return () => window.removeEventListener('hashchange', onChange)
}

function getRoute() {
  return window.location.hash.replace(/^#\/?/, '')
}

/** The current page id, or `''` for the catalog. */
export function useRoute(): string {
  return useSyncExternalStore(subscribe, getRoute)
}

export function pageHref(id: string) {
  return `#/${id}`
}

export const catalogHref = '#/'
