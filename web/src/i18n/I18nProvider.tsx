import { useCallback, useEffect, useMemo, useState } from 'react'
import type { ReactNode } from 'react'
import { I18nContext, languages, translate } from './i18n'
import type { I18n, Language } from './i18n'

const STORAGE_KEY = 'ds.language'

/** Saved choice first, then the browser language, then English. */
function initialLanguage(): Language {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved && (languages as readonly string[]).includes(saved)) return saved as Language
  } catch {
    // Storage can be blocked; fall through to the browser language.
  }
  return navigator.language.toLowerCase().startsWith('ja') ? 'ja' : 'en'
}

export function I18nProvider({ children }: { children: ReactNode }) {
  const [language, setLanguageState] = useState<Language>(initialLanguage)

  const setLanguage = useCallback((next: Language) => {
    setLanguageState(next)
    try {
      localStorage.setItem(STORAGE_KEY, next)
    } catch {
      // Not persisted; the choice still applies for this session.
    }
  }, [])

  // `lang` drives screen-reader pronunciation and the Japanese font fallback (`:lang(ja)`).
  useEffect(() => {
    document.documentElement.lang = language
  }, [language])

  const value = useMemo<I18n>(
    () => ({ language, setLanguage, t: (key, vars) => translate(language, key, vars) }),
    [language, setLanguage],
  )

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>
}
