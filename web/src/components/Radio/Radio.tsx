import { useId } from 'react'
import type { InputHTMLAttributes } from 'react'
import './Radio.css'

export interface RadioProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'role'> {
  label?: string
  /** Error state: red ring, `aria-invalid`. */
  invalid?: boolean
}

/**
 * Native radio with the Figma look. Use inside a `RadioGroup` (shared `name`, arrow-key navigation);
 * a lone Radio is a mistake. Unselected/Selected is `:checked`, Default/Disabled is `:disabled`.
 */
export function Radio({ label, invalid, className, id, ...rest }: RadioProps) {
  const autoId = useId()
  const classes = ['radio', invalid && 'radio--invalid', className].filter(Boolean).join(' ')
  return (
    <label className={classes}>
      <input
        id={id ?? autoId}
        type="radio"
        className="radio__input"
        aria-invalid={invalid || undefined}
        {...rest}
      />
      <span className="radio__circle" aria-hidden="true">
        <span className="radio__dot" />
      </span>
      {label && <span className="radio__label text-body-1">{label}</span>}
    </label>
  )
}
