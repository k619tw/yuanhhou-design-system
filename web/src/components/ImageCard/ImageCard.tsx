import { useId, type CSSProperties, type HTMLAttributes, type ReactNode } from 'react'
import { Icon } from '../Icon/Icon'
import './ImageCard.css'

export type ImageCardVariant = 'elevated' | 'outlined' | 'filled' | 'plain'
export type ImageCardSize = 'medium' | 'large'

export interface ImageCardProps extends Omit<HTMLAttributes<HTMLElement>, 'title'> {
  orientation?: 'vertical' | 'horizontal'
  /** Figma `Style`. Elevated (the default), Outlined and Filled are the Card styles; Plain has no container. */
  variant?: ImageCardVariant
  /** Figma `Size`. Medium: Headline title, Body 2 text. Large: Title 2 title, Body 1 text, roomier. */
  size?: ImageCardSize
  /** Media slot: any image or media. Fills the image area. */
  media?: ReactNode
  /** CSS aspect ratio of the media in a vertical card. Default 16 / 9 (180 high at 320 wide). */
  mediaRatio?: string
  /** `Badge` row: one or more <Badge size="small" badgeStyle="subtle" />. It wraps. */
  badge?: ReactNode
  title: ReactNode
  /** Heading level of the title, to fit the page outline. */
  titleAs?: 'h2' | 'h3' | 'h4'
  description?: ReactNode
  /** `Actions` row: real Button / IconButton elements. Not used when `href` is set. */
  actions?: ReactNode
  /** Makes the whole card one link. Its name is `linkLabel` plus the title. */
  href?: string
  /** The visible link text in the link row, for example "Read the case study". Required with `href`. */
  linkLabel?: ReactNode
  /** A short note after the link (for example a lock icon and "Password needed"). Read as the link's description. */
  linkNote?: ReactNode
  /** Extra attributes for the link, such as `target`, `rel` or `onClick`. */
  linkProps?: Omit<HTMLAttributes<HTMLAnchorElement>, 'children'> & { target?: string; rel?: string }
}

/**
 * Media, badges, a title, a description, then actions or one link. With `href` the link row's link is stretched over
 * the whole card, so the card is one tap target with a short name (link + title), not every word inside it.
 */
export function ImageCard({
  orientation = 'vertical',
  variant = 'elevated',
  size = 'medium',
  media,
  mediaRatio,
  badge,
  title,
  titleAs: Title = 'h3',
  description,
  actions,
  href,
  linkLabel,
  linkNote,
  linkProps,
  className,
  style,
  ...rest
}: ImageCardProps) {
  const id = useId()
  const ids = { title: `${id}-title`, link: `${id}-link`, note: `${id}-note` }
  const linked = href !== undefined
  const classes = [
    'image-card',
    `image-card--${orientation}`,
    `image-card--${variant}`,
    `image-card--${size}`,
    linked && 'image-card--linked',
    className,
  ]
    .filter(Boolean)
    .join(' ')
  const ratio = mediaRatio ? ({ '--image-card-ratio': mediaRatio } as CSSProperties) : undefined
  return (
    <article className={classes} style={{ ...ratio, ...style }} {...rest}>
      <div className="image-card__media">{media}</div>
      <div className="image-card__body">
        {badge && <div className="image-card__badge">{badge}</div>}
        <div className="image-card__text">
          <Title id={ids.title} className={`image-card__title ${size === 'large' ? 'text-title-2' : 'text-headline'} text-emphasized`}>
            {title}
          </Title>
          {description && <p className={`image-card__description ${size === 'large' ? 'text-body-1' : 'text-body-2'}`}>{description}</p>}
        </div>
        {linked ? (
          <div className="image-card__link-row">
            <a
              {...linkProps}
              id={ids.link}
              className="image-card__link text-body-2 text-emphasized"
              href={href}
              aria-labelledby={`${ids.link} ${ids.title}`}
              aria-describedby={linkNote ? ids.note : undefined}
            >
              {linkLabel}
              <Icon name="chevron_right" size="sm" />
            </a>
            {linkNote && (
              <span id={ids.note} className="image-card__note text-caption-1">
                {linkNote}
              </span>
            )}
          </div>
        ) : (
          actions && <div className="image-card__actions">{actions}</div>
        )}
      </div>
    </article>
  )
}
