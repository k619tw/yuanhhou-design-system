import type { ButtonHTMLAttributes } from 'react'
import { Icon } from '../Icon/Icon'
import './Button.css'

export type ButtonType = 'primary' | 'secondary' | 'tertiary' | 'alert'
export type ButtonSize = 'large' | 'small'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  /** Figma `Type`. */
  variant?: ButtonType
  /** Figma `Size`: Large 48px (12px vertical padding + 24px line height), Small 36px. */
  size?: ButtonSize
  /** Material Symbols name for the `Show leading icon` slot. */
  leadingIcon?: string
  /** Material Symbols name for the `Show trailing icon` slot. */
  trailingIcon?: string
  /** Fill the container width (layout concern, not a Figma variant). */
  fullWidth?: boolean
}

/** Pressed and Disabled are `:active` and `:disabled`, not props. */
export function Button({
  variant = 'primary',
  size = 'large',
  leadingIcon,
  trailingIcon,
  fullWidth,
  className,
  children,
  type = 'button',
  ...rest
}: ButtonProps) {
  const classes = ['btn', `btn--${variant}`, `btn--${size}`, fullWidth && 'btn--full', className]
    .filter(Boolean)
    .join(' ')
  return (
    <button type={type} className={classes} {...rest}>
      {leadingIcon && <Icon name={leadingIcon} size="md" />}
      <span className="btn__label">{children}</span>
      {trailingIcon && <Icon name={trailingIcon} size="md" />}
    </button>
  )
}
