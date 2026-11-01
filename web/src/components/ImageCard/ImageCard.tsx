import type { HTMLAttributes, ReactNode } from 'react'
import './ImageCard.css'

export interface ImageCardProps extends Omit<HTMLAttributes<HTMLElement>, 'title'> {
  orientation?: 'vertical' | 'horizontal'
  /** Media slot: any image or media. Fills the image area. */
  media?: ReactNode
  /** `Badge` row; pass a <Badge size="small" badgeStyle="subtle" />. */
  badge?: ReactNode
  title: ReactNode
  description?: ReactNode
  /** `Actions` row: real Button / IconButton elements. */
  actions?: ReactNode
}

/** The card itself is not clickable; wrap it in a link in code if it needs to be. */
export function ImageCard({
  orientation = 'vertical',
  media,
  badge,
  title,
  description,
  actions,
  className,
  ...rest
}: ImageCardProps) {
  const classes = ['image-card', `image-card--${orientation}`, className].filter(Boolean).join(' ')
  return (
    <article className={classes} {...rest}>
      <div className="image-card__media">{media}</div>
      <div className="image-card__body">
        {badge && <div className="image-card__badge">{badge}</div>}
        <h3 className="image-card__title text-headline">{title}</h3>
        {description && <p className="image-card__description text-body-2">{description}</p>}
        {actions && <div className="image-card__actions">{actions}</div>}
      </div>
    </article>
  )
}
