import { useId, useState } from 'react'
import type { ChangeEvent, CSSProperties, ReactNode } from 'react'
import './SegmentedControl.css'

export interface SegmentedOption<T extends string = string> {
  value: T
  /** Visible content: short text, or text with a small display-only mark. */
  label: ReactNode
  /** Accessible name when `label` is not plain text or is abbreviated (for example "EN" for "English"). */
  ariaLabel?: string
  /** Language of the label, when it differs from the page (for example "ja" for 日本語). */
  lang?: string
  disabled?: boolean
}

export interface SegmentedControlProps<T extends string = string> {
  /** Accessible name of the group (`aria-label`). */
  label: string
  /** 2 to 5 short options. */
  options: SegmentedOption<T>[]
  /** Controlled value. Omit to let the control manage its own state. */
  value?: T
  defaultValue?: T
  /** Called when the selection changes. The event's `currentTarget` is the chosen segment's input, which covers the segment. */
  onValueChange?: (value: T, event: ChangeEvent<HTMLInputElement>) => void
  /** Large: 48 high (Button 2 text). Small: 40 high (Caption 1 text), for dense bars. */
  size?: 'large' | 'small'
  /** Stretch the track to the width of its container. */
  fullWidth?: boolean
  disabled?: boolean
  name?: string
  className?: string
}

/**
 * Pick one of 2 to 5 short options that switch a view or a setting right away (the HIG segmented control,
 * Material 3 single-select segmented buttons). Native radios sharing one `name`, so Tab enters at the selected
 * option and arrow keys move the selection. Segments share the width equally; one thumb slides under the choice.
 */
export function SegmentedControl<T extends string = string>({
  label,
  options,
  value,
  defaultValue,
  onValueChange,
  size = 'large',
  fullWidth,
  disabled,
  name,
  className,
}: SegmentedControlProps<T>) {
  const autoName = useId()
  const [inner, setInner] = useState(defaultValue)
  const selected = value ?? inner
  const index = options.findIndex((o) => o.value === selected)
  const classes = ['segmented-control', `segmented-control--${size}`, fullWidth && 'segmented-control--full', className]
    .filter(Boolean)
    .join(' ')
  const style = { '--segmented-count': options.length, '--segmented-index': Math.max(index, 0) } as CSSProperties
  return (
    <div role="radiogroup" aria-label={label} aria-disabled={disabled || undefined} className={classes} style={style}>
      {index >= 0 && <span className="segmented-control__thumb" aria-hidden="true" />}
      {options.map((o) => (
        <label key={o.value} className="segmented-control__option">
          <input
            type="radio"
            className="segmented-control__input"
            name={name ?? autoName}
            value={o.value}
            checked={selected === o.value}
            disabled={disabled || o.disabled}
            aria-label={o.ariaLabel}
            onChange={(event) => {
              setInner(o.value)
              onValueChange?.(o.value, event)
            }}
          />
          <span className="segmented-control__label" lang={o.lang}>
            {o.label}
          </span>
        </label>
      ))}
    </div>
  )
}
