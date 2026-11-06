import type { HTMLAttributes } from 'react'
import { Icon } from '../Icon/Icon'
import './Badge.css'

export type BadgeType = 'brand' | 'info' | 'success' | 'warning' | 'error' | 'promote'

export interface BadgeProps extends HTMLAttributes<HTMLSpanElement> {
  type?: BadgeType
  /** Solid = high emphasis, Subtle = low emphasis (the default). */
  badgeStyle?: 'solid' | 'subtle'
  size?: 'medium' | 'small'
  /** Material Symbols name for the optional display-only icon. */
  icon?: string
}

/** Non-interactive status label. Use Button or a chip if it must be clickable. */
export function Badge({
  type = 'brand',
  badgeStyle = 'subtle',
  size = 'medium',
  icon,
  className,
  children,
  ...rest
}: BadgeProps) {
  const classes = ['badge', `badge--${type}`, `badge--${badgeStyle}`, `badge--${size}`, className]
    .filter(Boolean)
    .join(' ')
  return (
    <span className={classes} {...rest}>
      {icon && <Icon name={icon} size="sm" />}
      {children}
    </span>
  )
}
