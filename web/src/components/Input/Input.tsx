import { useId } from 'react'
import type { InputHTMLAttributes, ReactNode } from 'react'
import { Icon } from '../Icon/Icon'
import './Input.css'

export interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label?: string
  helper?: string
  /** Error state: red outline, `aria-invalid`. Keep `helper` as the error message. */
  invalid?: boolean
  /** Medium 40px, Large 48px. */
  size?: 'medium' | 'large'
  /** Material Symbols name. Display only. */
  leadingIcon?: string
  /** Interactive trailing control (an IconButton with aria-label, e.g. clear). */
  trailingAction?: ReactNode
}

/** Focus is `:focus-within`, Disabled is `disabled`. */
export function Input({
  label,
  helper,
  invalid,
  size = 'medium',
  leadingIcon,
  trailingAction,
  className,
  id,
  ...rest
}: InputProps) {
  const autoId = useId()
  const inputId = id ?? autoId
  const helperId = `${inputId}-helper`
  const classes = ['input', `input--${size}`, invalid && 'input--invalid', className]
    .filter(Boolean)
    .join(' ')
  return (
    <div className={classes}>
      {label && (
        <label className="input__label text-body-2 text-emphasized" htmlFor={inputId}>
          {label}
        </label>
      )}
      <div className="input__field">
        {leadingIcon && <Icon name={leadingIcon} size="md" className="input__leading" />}
        <input
          id={inputId}
          className="input__control"
          aria-invalid={invalid || undefined}
          aria-describedby={helper ? helperId : undefined}
          {...rest}
        />
        {trailingAction && <div className="input__trailing">{trailingAction}</div>}
      </div>
      {helper && (
        <p id={helperId} className="input__helper text-caption-1">
          {helper}
        </p>
      )}
    </div>
  )
}
