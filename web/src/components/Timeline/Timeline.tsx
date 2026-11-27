import type { CSSProperties, HTMLAttributes, ReactNode } from 'react'
import './Timeline.css'

export type TimelineSize = 'medium' | 'large'

export interface TimelineItem {
  key?: string
  /** Optional line above the title, such as a date. Caption 1 Emphasized in the brand colour. */
  label?: ReactNode
  title: ReactNode
  description?: ReactNode
}

export interface TimelineProps extends HTMLAttributes<HTMLOListElement> {
  items: TimelineItem[]
  /** Figma `Size`. Medium: Body 1 titles, 24 apart. Large: Title 3 titles, 32 apart. */
  size?: TimelineSize
  /**
   * How much of the line is filled in `action/primary`, 0 to 1, from the top. Leave it out for no fill. To drive it
   * from scroll without re-rendering, set the `--timeline-progress` CSS variable on the list instead.
   */
  progress?: number
}

/** An ordered list of moments on a vertical line: experience, milestones, release history. */
export function Timeline({ items, size = 'medium', progress, className, style, ...rest }: TimelineProps) {
  const classes = ['timeline', `timeline--${size}`, className].filter(Boolean).join(' ')
  const fill = progress === undefined ? undefined : ({ '--timeline-progress': Math.min(Math.max(progress, 0), 1) } as CSSProperties)
  return (
    <ol className={classes} style={{ ...fill, ...style }} {...rest}>
      {items.map((item, i) => (
        <li key={item.key ?? i} className="timeline__item">
          {item.label && <span className="timeline__label text-caption-1 text-emphasized">{item.label}</span>}
          <span className={`timeline__title ${size === 'large' ? 'text-title-3 text-emphasized' : 'text-body-1'}`}>{item.title}</span>
          {item.description && (
            <span className={`timeline__description ${size === 'large' ? 'text-body-1' : 'text-body-2'}`}>{item.description}</span>
          )}
        </li>
      ))}
    </ol>
  )
}
