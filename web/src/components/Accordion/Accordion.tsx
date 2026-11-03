import { useId, useState } from 'react'
import type { ReactNode } from 'react'
import { Icon } from '../Icon/Icon'
import './Accordion.css'

export interface AccordionProps {
  title: ReactNode
  children: ReactNode
  /** Uncontrolled initial state. */
  defaultExpanded?: boolean
  /** Controlled state; pair with `onExpandedChange`. */
  expanded?: boolean
  onExpandedChange?: (expanded: boolean) => void
  disabled?: boolean
  className?: string
}

/**
 * One accordion item, text based like the iOS disclosure group: a label with a chevron
 * (`chevron_right` closed, `expand_more` open) that opens text right under the label.
 * The whole header is a single button (`aria-expanded`, `aria-controls`); the chevron is a
 * display-only Utility Icon, not a nested button, which would be invalid inside a button.
 * Stack items for a group; single- vs multi-open is up to the caller.
 */
export function Accordion({
  title,
  children,
  defaultExpanded = false,
  expanded: expandedProp,
  onExpandedChange,
  disabled,
  className,
}: AccordionProps) {
  const [inner, setInner] = useState(defaultExpanded)
  const expanded = expandedProp ?? inner
  const id = useId()
  const toggle = () => {
    if (disabled) return
    if (expandedProp === undefined) setInner(!expanded)
    onExpandedChange?.(!expanded)
  }
  return (
    <div className={['accordion', className].filter(Boolean).join(' ')}>
      <button
        type="button"
        id={`${id}-header`}
        className="accordion__header"
        aria-expanded={expanded}
        aria-controls={`${id}-content`}
        disabled={disabled}
        onClick={toggle}
      >
        <span className="accordion__title text-body-1">{title}</span>
        <span className="accordion__chevron">
          <Icon name={expanded ? 'expand_more' : 'chevron_right'} size="md" />
        </span>
      </button>
      <div
        id={`${id}-content`}
        role="region"
        aria-labelledby={`${id}-header`}
        className="accordion__content text-body-2"
        hidden={!expanded}
      >
        {children}
      </div>
    </div>
  )
}
