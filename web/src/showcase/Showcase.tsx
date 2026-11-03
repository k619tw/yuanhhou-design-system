import { useEffect, useRef } from 'react'
import type { ReactNode } from 'react'
import { Icon } from '@yuanhhou/ds'
import { useI18n } from '@/i18n/i18n'
import { catalogHref } from './router'
import './Showcase.css'

/** A showcase page: a link back to the catalog, the title and the page's sections (iOS: `DSShowcasePage`). */
export function ShowcasePage({ title, children }: { title: string; children: ReactNode }) {
  const { t } = useI18n()
  const heading = useRef<HTMLHeadingElement>(null)

  // Opening a page is a navigation: start at the top and move focus to the new title for screen readers.
  useEffect(() => {
    window.scrollTo(0, 0)
    heading.current?.focus()
  }, [])

  return (
    <article className="showcase-page">
      <a className="showcase-page__back text-body-2 text-emphasized" href={catalogHref}>
        <Icon name="chevron_left" size="sm" />
        {t('nav.allPages')}
      </a>
      <h2 ref={heading} tabIndex={-1} className="showcase-page__title">
        {title}
      </h2>
      {children}
    </article>
  )
}

/** A titled group of examples on a page (iOS: `DSShowcaseSection`). */
export function ShowcaseSection({ title, note, children }: { title?: string; note?: string; children: ReactNode }) {
  return (
    <section className="showcase-section">
      {(title || note) && (
        <div className="showcase-section__intro">
          {title && <h3>{title}</h3>}
          {note && <p className="showcase-note text-body-2">{note}</p>}
        </div>
      )}
      {children}
    </section>
  )
}
