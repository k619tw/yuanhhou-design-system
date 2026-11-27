import type { AnchorHTMLAttributes, HTMLAttributes, ReactNode } from 'react'
import './Card.css'

export type CardVariant = 'filled' | 'outlined' | 'elevated'
export type CardPadding = 'default' | 'comfortable' | 'none'
export type CardSurface = 'primary' | 'secondary'

interface CardBaseProps {
  /** Figma `Style`. Filled = one step off the surface, Outlined = hairline, Elevated = hairline and shadow. */
  variant?: CardVariant
  /** Figma `Surface`: the background the card sits on. Filled and Outlined take their fill from it. */
  surface?: CardSurface
  /** Figma `Padding`: Default 16, Comfortable 24, None 0 (for full-bleed media inside). */
  padding?: CardPadding
  children?: ReactNode
}

export type CardProps = CardBaseProps &
  (
    | ({ href?: undefined; as?: 'div' | 'article' | 'section' | 'li' } & HTMLAttributes<HTMLElement>)
    | ({ href: string; as?: never } & AnchorHTMLAttributes<HTMLAnchorElement>)
  )

/**
 * A surface that groups free-form content. With `href` the whole card is one link (`<a>`): its whole text is the
 * link's name, so keep such cards short. For a card with media and one link, use `ImageCard` with `href`.
 */
export function Card({ variant = 'filled', surface = 'primary', padding = 'default', className, children, ...rest }: CardProps) {
  const classes = [
    'card',
    `card--${variant}`,
    surface === 'secondary' && 'card--on-secondary',
    `card--pad-${padding}`,
    rest.href !== undefined && 'card--interactive',
    className,
  ]
    .filter(Boolean)
    .join(' ')
  if (rest.href !== undefined) {
    const { as: _as, ...link } = rest as AnchorHTMLAttributes<HTMLAnchorElement> & { as?: never }
    return (
      <a className={classes} {...link}>
        {children}
      </a>
    )
  }
  const { as: Tag = 'div', ...props } = rest as HTMLAttributes<HTMLElement> & { as?: 'div' | 'article' | 'section' | 'li' }
  return (
    <Tag className={classes} {...props}>
      {children}
    </Tag>
  )
}
