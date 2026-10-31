import { useId } from 'react'
import type { InputHTMLAttributes } from 'react'
import './Toggle.css'

export interface ToggleProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'role'> {
  label?: string
}

/**
 * Switch built on a native checkbox (`role="switch"`), so it works in forms and
 * `:checked` / `:disabled` drive Off/On and Default/Disabled. The label is part of the click target.
 */
export function Toggle({ label, className, id, ...rest }: ToggleProps) {
  const autoId = useId()
  return (
    <label className={['toggle', className].filter(Boolean).join(' ')}>
      <input id={id ?? autoId} type="checkbox" role="switch" className="toggle__input" {...rest} />
      <span className="toggle__track" aria-hidden="true">
        <span className="toggle__knob" />
      </span>
      {label && <span className="toggle__label text-body-1">{label}</span>}
    </label>
  )
}
