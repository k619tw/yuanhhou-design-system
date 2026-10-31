import { createContext, useContext } from 'react'
import { en, ja } from './messages'
import type { MessageKey } from './messages'

export const languages = ['en', 'ja'] as const
export type Language = (typeof languages)[number]

/** Each language is named in its own language in the switcher. */
export const languageNames: Record<Language, string> = { en: 'English', ja: '日本語' }

const dictionaries: Record<Language, Record<MessageKey, string>> = { en, ja }

export interface I18n {
  language: Language
  setLanguage: (language: Language) => void
  t: (key: MessageKey, vars?: Record<string, string>) => string
}

export function translate(language: Language, key: MessageKey, vars?: Record<string, string>) {
  const template = dictionaries[language][key] ?? en[key]
  return vars ? template.replace(/\{(\w+)\}/g, (match, name: string) => vars[name] ?? match) : template
}

export const I18nContext = createContext<I18n | null>(null)

/** `const { t, language, setLanguage } = useI18n()` inside `<I18nProvider>`. */
export function useI18n(): I18n {
  const context = useContext(I18nContext)
  if (!context) throw new Error('useI18n must be used inside <I18nProvider>')
  return context
}
