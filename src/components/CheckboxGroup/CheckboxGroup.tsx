import { useId, useState } from 'react'
import { Checkbox } from '../Checkbox/Checkbox'
import './SelectionGroup.css'

export interface CheckboxOption {
  value: string
  label: string
  disabled?: boolean
}

export interface CheckboxGroupProps {
  legend: string
  options: CheckboxOption[]
  /** Controlled selected values. Omit to let the group manage its own state. */
  value?: string[]
  defaultValue?: string[]
  onValueChange?: (value: string[]) => void
  name?: string
  helper?: string
  invalid?: boolean
  disabled?: boolean
  orientation?: 'vertical' | 'horizontal'
  className?: string
}

/** Pick any number of options. A `fieldset` with a legend plus native checkboxes sharing one `name`. */
export function CheckboxGroup({
  legend,
  options,
  value,
  defaultValue = [],
  onValueChange,
  name,
  helper,
  invalid,
  disabled,
  orientation = 'vertical',
  className,
}: CheckboxGroupProps) {
  const autoName = useId()
  const helperId = `${autoName}-helper`
  const [inner, setInner] = useState(defaultValue)
  const selected = value ?? inner
  const toggle = (v: string, on: boolean) => {
    const next = on ? [...selected, v] : selected.filter((s) => s !== v)
    setInner(next)
    onValueChange?.(next)
  }
  const classes = ['selection-group', `selection-group--${orientation}`, invalid && 'selection-group--invalid', className]
    .filter(Boolean)
    .join(' ')
  return (
    <fieldset
      className={classes}
      disabled={disabled}
      aria-invalid={invalid || undefined}
      aria-describedby={helper ? helperId : undefined}
    >
      <legend className="selection-group__legend text-body-2 text-emphasized">{legend}</legend>
      <div className="selection-group__options">
        {options.map((o) => (
          <Checkbox
            key={o.value}
            name={name ?? autoName}
            value={o.value}
            label={o.label}
            disabled={o.disabled}
            invalid={invalid}
            checked={selected.includes(o.value)}
            onChange={(e) => toggle(o.value, e.target.checked)}
          />
        ))}
      </div>
      {helper && (
        <p id={helperId} className="selection-group__helper text-caption-1">
          {helper}
        </p>
      )}
    </fieldset>
  )
}
