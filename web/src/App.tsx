import { useEffect, useState } from 'react'
import { languageNames, languages, useI18n } from '@/i18n/i18n'
import type { Language } from '@/i18n/i18n'
import { Catalog } from '@/showcase/Catalog'
import { findPage } from '@/showcase/pages'
import { catalogHref, useRoute } from '@/showcase/router'
import './App.css'

const themes = ['default', 'eva', 'heritage-luxury'] as const
const appearances = ['light', 'dark'] as const
const densities = ['compact', 'default', 'loose'] as const

function App() {
  const { t, language, setLanguage } = useI18n()
  const [theme, setTheme] = useState<(typeof themes)[number]>('default')
  const [appearance, setAppearance] = useState<(typeof appearances)[number]>('light')
  const [density, setDensity] = useState<(typeof densities)[number]>('default')
  const page = findPage(useRoute())

  useEffect(() => {
    // Every theme has a Light and a Dark mode: data-theme is light, dark or <theme>-<appearance>.
    document.documentElement.dataset.theme = theme === 'default' ? appearance : `${theme}-${appearance}`
    document.documentElement.dataset.density = density
  }, [theme, appearance, density])

  return (
    <main className="showcase">
      <header className="showcase__header">
        <h1>
          <a className="showcase__home" href={catalogHref}>
            {t('appTitle')}
          </a>
        </h1>
        <div className="showcase__controls">
          <label className="text-body-2">
            {t('language')}{' '}
            <select id="language" name="language" value={language} onChange={(e) => setLanguage(e.target.value as Language)}>
              {languages.map((l) => (
                <option key={l} value={l} lang={l}>
                  {languageNames[l]}
                </option>
              ))}
            </select>
          </label>
          <label className="text-body-2">
            {t('theme')}{' '}
            <select id="theme" name="theme" value={theme} onChange={(e) => setTheme(e.target.value as typeof theme)}>
              {themes.map((th) => (
                <option key={th} value={th}>
                  {t(`theme.${th}`)}
                </option>
              ))}
            </select>
          </label>
          <label className="text-body-2">
            {t('appearance')}{' '}
            <select id="appearance" name="appearance" value={appearance} onChange={(e) => setAppearance(e.target.value as typeof appearance)}>
              {appearances.map((a) => (
                <option key={a} value={a}>
                  {t(`appearance.${a}`)}
                </option>
              ))}
            </select>
          </label>
          <label className="text-body-2">
            {t('density')}{' '}
            <select id="density" name="density" value={density} onChange={(e) => setDensity(e.target.value as typeof density)}>
              {densities.map((d) => (
                <option key={d} value={d}>
                  {t(`density.${d}`)}
                </option>
              ))}
            </select>
          </label>
        </div>
      </header>

      {/* Keyed by page so each page starts fresh, like a pushed screen on iOS. */}
      {page ? <page.Page key={page.id} /> : <Catalog />}
    </main>
  )
}

export default App
