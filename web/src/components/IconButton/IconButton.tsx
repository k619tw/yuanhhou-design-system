import type { ButtonHTMLAttributes } from 'react'
import { Icon } from '../Icon/Icon'
import type { IconSize } from '../Icon/Icon'
import './IconButton.css'

export type IconButtonType = 'primary' | 'secondary' | 'tertiary' | 'alert'
export type IconButtonSize = 'large' | 'small'

export interface IconButtonProps extends Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'children'> {
  /** Material Symbols name. */
  icon: string
  /** Required accessible name: the icon alone has no text. */
  'aria-label': string
  variant?: IconButtonType
  /** Large 48px, Small 32px. */
  size?: IconButtonSize
  /** Glyph size; Figma variants use 24px (`lg`), nested uses (Input, Accordion) override to 20px (`md`). */
  iconSize?: IconSize
}

/** Interactive icon-only button. For a display-only icon use Icon. */
export function IconButton({
  icon,
  variant = 'primary',
  size = 'large',
  iconSize = 'lg',
  className,
  type = 'button',
  ...rest
}: IconButtonProps) {
  const classes = ['icon-btn', `icon-btn--${variant}`, `icon-btn--${size}`, className]
    .filter(Boolean)
    .join(' ')
  return (
    <button type={type} className={classes} {...rest}>
      <Icon name={icon} size={iconSize} />
    </button>
  )
}
