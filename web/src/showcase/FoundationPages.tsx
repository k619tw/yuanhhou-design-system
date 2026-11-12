import { Icon } from '@yuanhhou/ds'
import { useI18n } from '@/i18n/i18n'
import type { MessageKey } from '@/i18n/messages'
import { cssVar, useDocumentMode } from './documentMode'
import { ShowcasePage, ShowcaseSection } from './Showcase'

/**
 * Names of the `:root` custom properties that start with `prefix`, in `tokens.css` order. Read from the
 * loaded stylesheets, so the gallery always lists exactly the tokens the components use.
 */
function rootProperties(prefix: string): string[] {
  const names: string[] = []
  const visit = (rules: CSSRuleList) => {
    for (const rule of Array.from(rules)) {
      if (rule instanceof CSSImportRule && rule.styleSheet) {
        visit(rule.styleSheet.cssRules)
      } else if (rule instanceof CSSStyleRule && rule.selectorText.split(',').some((s) => s.trim() === ':root')) {
        for (const name of Array.from(rule.style)) {
          if (name.startsWith(prefix) && !names.includes(name)) names.push(name)
        }
      }
    }
  }
  for (const sheet of Array.from(document.styleSheets)) {
    try {
      visit(sheet.cssRules)
    } catch {
      // Cross-origin stylesheets (the web fonts) cannot be read; they hold no tokens.
    }
  }
  return names
}

const colorGroups: { role: string; title: MessageKey }[] = [
  { role: 'background', title: 'colors.background' },
  { role: 'foreground', title: 'colors.foreground' },
  { role: 'border', title: 'colors.border' },
  { role: 'action', title: 'colors.action' },
  { role: 'ai', title: 'colors.ai' },
]

export function ColorsPage() {
  const { t } = useI18n()
  const { theme } = useDocumentMode()
  const tokens = rootProperties('--color-')

  return (
    <ShowcasePage title={t('page.colors')}>
      <p className="showcase-note text-body-2">{t('colors.note', { mode: theme })}</p>
      {colorGroups.map(({ role, title }) => (
        <ShowcaseSection key={role} title={t(title)}>
          <div className="swatch-grid">
            {tokens
              .filter((name) => name.startsWith(`--color-${role}-`))
              .map((name) => (
                <div className="swatch" key={name}>
                  <div className="swatch__color" style={{ background: `var(${name})` }} />
                  <span className="swatch__name text-caption-1 text-emphasized">{name.replace('--color-', '')}</span>
                  <code className="swatch__value text-caption-2">{cssVar(name)}</code>
                </div>
              ))}
          </div>
        </ShowcaseSection>
      ))}
    </ShowcasePage>
  )
}

// Figma text styles, in Figma order. Names are the Figma style names, so they are not translated.
const textStyles = [
  ['Large Title', 'large-title'],
  ['Title 1', 'title-1'],
  ['Title 2', 'title-2'],
  ['Title 3', 'title-3'],
  ['Headline', 'headline'],
  ['Body 1', 'body-1'],
  ['Body 2', 'body-2'],
  ['Button 1', 'button-1'],
  ['Button 2', 'button-2'],
  ['Caption 1', 'caption-1'],
  ['Caption 2', 'caption-2'],
] as const

export function TypographyPage() {
  const { t } = useI18n()
  // Re-render on a density change so the printed sizes follow it.
  useDocumentMode()

  return (
    <ShowcasePage title={t('page.typography')}>
      <p className="showcase-note text-body-2">{t('typography.note')}</p>
      {textStyles.map(([name, id]) => {
        const size = parseFloat(cssVar(`--typography-${id}-size`))
        const lineHeight = parseFloat(cssVar(`--typography-${id}-line-height`))
        return (
          <div className="type-sample" key={id}>
            <span className="token-meta text-caption-1">
              {name} · .text-{id} · {size}/{lineHeight}
            </span>
            <p className={`text-${id} type-sample__regular`}>{t('typography.regular')}</p>
            <p className={`text-${id} text-emphasized`}>{t('typography.emphasized')}</p>
          </div>
        )
      })}
    </ShowcasePage>
  )
}

const spacing = ['2xs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl']
// The semantic radii follow the brand (generated per theme in shape.css), so they change with the Theme picker.
const radii = ['control', 'card', 'dialog', 'sheet', 'pill'] as const

export function SpacingPage() {
  const { t } = useI18n()
  // Re-read the radii when the theme changes: they follow the brand.
  useDocumentMode()

  return (
    <ShowcasePage title={t('page.spacing')}>
      <ShowcaseSection title={t('spacing.spacing')}>
        {spacing.map((name) => (
          <div className="spacing-row" key={name}>
            <span className="spacing-row__label text-body-2">
              {name} · {parseFloat(cssVar(`--spacing-${name}`))}
            </span>
            <div className="spacing-row__bar" style={{ width: `var(--spacing-${name})` }} />
          </div>
        ))}
      </ShowcaseSection>
      <ShowcaseSection title={t('spacing.radius')}>
        <p className="text-body-2">{t('spacing.radiusNote')}</p>
        <div className="radius-grid">
          {radii.map((name) => (
            <div className="radius-sample" key={name}>
              <div className="radius-sample__shape" style={{ borderRadius: `var(--radius-${name})` }} />
              <span className="token-meta text-caption-1">
                {name} · {parseFloat(cssVar(`--radius-${name}`))}
              </span>
            </div>
          ))}
        </div>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

// The 30 Utility Icons (Figma page `Icons`), by Material Symbols name.
const utilityIcons = [
  'home', 'search', 'menu', 'close', 'settings', 'person', 'favorite', 'star', 'add', 'remove',
  'check', 'arrow_back', 'arrow_forward', 'chevron_left', 'chevron_right', 'expand_more', 'expand_less',
  'more_horiz', 'more_vert', 'delete', 'edit', 'share', 'info', 'warning', 'error', 'notifications',
  'mail', 'calendar_today', 'visibility', 'download',
]

export function IconsPage() {
  const { t } = useI18n()

  return (
    <ShowcasePage title={t('page.icons')}>
      <p className="showcase-note text-body-2">{t('icons.note')}</p>
      <div className="icon-grid">
        {utilityIcons.map((name) => (
          <div className="icon-sample" key={name}>
            <Icon name={name} size="lg" />
            <span className="text-caption-1 text-emphasized">{name}</span>
          </div>
        ))}
      </div>
    </ShowcasePage>
  )
}
