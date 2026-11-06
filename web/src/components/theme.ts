export type ThemeBrand = 'default' | 'eva' | 'heritage-luxury'

let stopFollowing: (() => void) | undefined

/**
 * Applies a brand palette to the page and keeps it in step with the device's Light or Dark setting,
 * like `.dsTheme(_:)` on iOS. Call it once when the app starts. Returns a function that stops following.
 * To force one mode instead, set `data-theme` on `<html>` yourself.
 */
export function applyTheme(brand: ThemeBrand = 'default'): () => void {
  stopFollowing?.()
  const dark = window.matchMedia('(prefers-color-scheme: dark)')
  const update = () => {
    const appearance = dark.matches ? 'dark' : 'light'
    document.documentElement.dataset.theme = brand === 'default' ? appearance : `${brand}-${appearance}`
  }
  update()
  dark.addEventListener('change', update)
  const stop = () => {
    dark.removeEventListener('change', update)
    if (stopFollowing === stop) stopFollowing = undefined
  }
  stopFollowing = stop
  return stop
}
