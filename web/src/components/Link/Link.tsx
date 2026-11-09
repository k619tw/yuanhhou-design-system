import { forwardRef } from 'react'
import type { AnchorHTMLAttributes } from 'react'
import './Link.css'

export type LinkSize = 'body-1' | 'body-2' | 'caption-1'

export interface LinkProps extends AnchorHTMLAttributes<HTMLAnchorElement> {
  /** Figma `Size`: the Emphasized weight of Body 1, Body 2 or Caption 1. Match the text around the link. */
  size?: LinkSize
}

/**
 * A text link that goes somewhere (a page, a section, a site). Renders a real `<a>`; for actions use `Button`.
 * Hover thickens the underline; focus is a 2px `--color-border-focus` outline. All anchor props and the ref
 * are forwarded.
 */
export const Link = forwardRef<HTMLAnchorElement, LinkProps>(function Link(
  { size = 'body-1', className, children, ...rest },
  ref,
) {
  const classes = ['link', `link--${size}`, className].filter(Boolean).join(' ')
  return (
    <a ref={ref} className={classes} {...rest}>
      {children}
    </a>
  )
})
