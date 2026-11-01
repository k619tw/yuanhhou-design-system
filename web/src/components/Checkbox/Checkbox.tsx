import { useEffect, useId, useRef } from 'react'
import type { InputHTMLAttributes } from 'react'
import './Checkbox.css'

export interface CheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'role'> {
  label?: string
  /** Mixed state for a "select all" parent. Shown as a dash; set `checked` to false or true alongside it. */
  indeterminate?: boolean
  /** Error state: red box, `aria-invalid`. */
  invalid?: boolean
}

/**
 * Native checkbox with the Figma look. Unchecked/Checked/Indeterminate are `:checked` and the
 * `indeterminate` DOM property; Default/Disabled is `:disabled`. The label is part of the click target.
 */
export function Checkbox({ label, indeterminate = false, invalid, className, id, ...rest }: CheckboxProps) {
  const autoId = useId()
  const ref = useRef<HTMLInputElement>(null)
  useEffect(() => {
    if (ref.current) ref.current.indeterminate = indeterminate
  }, [indeterminate])
  const classes = ['checkbox', invalid && 'checkbox--invalid', className].filter(Boolean).join(' ')
  return (
    <label className={classes}>
      <input
        ref={ref}
        id={id ?? autoId}
        type="checkbox"
        className="checkbox__input"
        aria-invalid={invalid || undefined}
        {...rest}
      />
      <span className="checkbox__box" aria-hidden="true">
        <svg className="checkbox__mark checkbox__mark--check" viewBox="0 0 24 24">
          <path d="M5 12.5l4.5 4.5L19 7.5" />
        </svg>
        <svg className="checkbox__mark checkbox__mark--dash" viewBox="0 0 24 24">
          <path d="M6 12h12" />
        </svg>
      </span>
      {label && <span className="checkbox__label text-body-1">{label}</span>}
    </label>
  )
}
