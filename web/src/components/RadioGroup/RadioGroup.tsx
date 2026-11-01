import { useId, useState } from 'react'
import { Radio } from '../Radio/Radio'
import '../CheckboxGroup/SelectionGroup.css'

export interface RadioOption {
  value: string
  label: string
  disabled?: boolean
}

export interface RadioGroupProps {
  /** Visible group name (rendered as the fieldset legend). */
  legend: string
  options: RadioOption[]
  /** Controlled value. Omit to let the group manage its own state. */
  value?: string
  defaultValue?: string
  onValueChange?: (value: string) => void
  name?: string
  helper?: string
  /** Error state: red radios, `helper` becomes the error message. */
  invalid?: boolean
  required?: boolean
  disabled?: boolean
  /** Stack options (default) or lay them out in a row. */
  orientation?: 'vertical' | 'horizontal'
  className?: string
}

/**
 * Pick exactly one of 2 to 7 options. A `fieldset` with a legend plus native radios sharing one `name`,
 * so Tab enters the group, arrow keys move the selection and it posts with a form.
 */
export function RadioGroup({
  legend,
  options,
  value,
  defaultValue,
  onValueChange,
  name,
  helper,
  invalid,
  required,
  disabled,
  orientation = 'vertical',
  className,
}: RadioGroupProps) {
  const autoName = useId()
  const helperId = `${autoName}-helper`
  const [inner, setInner] = useState(defaultValue)
  const selected = value ?? inner
  const classes = ['selection-group', `selection-group--${orientation}`, invalid && 'selection-group--invalid', className]
    .filter(Boolean)
    .join(' ')
  return (
    <fieldset
      className={classes}
      disabled={disabled}
      aria-required={required || undefined}
      aria-invalid={invalid || undefined}
      aria-describedby={helper ? helperId : undefined}
    >
      <legend className="selection-group__legend text-body-2 text-emphasized">{legend}</legend>
      <div className="selection-group__options">
        {options.map((o) => (
          <Radio
            key={o.value}
            name={name ?? autoName}
            value={o.value}
            label={o.label}
            disabled={o.disabled}
            invalid={invalid}
            checked={selected === o.value}
            onChange={() => {
              setInner(o.value)
              onValueChange?.(o.value)
            }}
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
