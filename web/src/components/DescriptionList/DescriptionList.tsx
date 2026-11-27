import type { HTMLAttributes, ReactNode } from 'react'
import './DescriptionList.css'

export interface DescriptionItem {
  key?: string
  term: ReactNode
  details: ReactNode
}

export interface DescriptionListProps extends HTMLAttributes<HTMLDListElement> {
  items: DescriptionItem[]
  /** Figma `Layout`. Grid: pairs side by side in columns at least 200 wide. Rows: one pair per row with hairlines. */
  layout?: 'grid' | 'rows'
}

/** `Description List (Web)`: term and value pairs in a `<dl>`. iOS uses the native `LabeledContent`. */
export function DescriptionList({ items, layout = 'grid', className, ...rest }: DescriptionListProps) {
  const classes = ['description-list', `description-list--${layout}`, className].filter(Boolean).join(' ')
  return (
    <dl className={classes} {...rest}>
      {items.map((item, i) => (
        <div key={item.key ?? i} className="description-list__item">
          <dt className="description-list__term text-caption-1">{item.term}</dt>
          <dd className="description-list__details text-body-1">{item.details}</dd>
        </div>
      ))}
    </dl>
  )
}
