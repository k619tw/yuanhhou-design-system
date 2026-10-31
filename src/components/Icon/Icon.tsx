import type { CSSProperties } from 'react'
import './Icon.css'

export type IconSize = 'sm' | 'md' | 'lg'

export interface IconProps {
  /** Exact Material Symbols name, e.g. `search`, `expand_more`. */
  name: string
  size?: IconSize
  className?: string
}

/**
 * Utility Icon: display only (Material Symbols Rounded). If the icon itself triggers
 * an action, use IconButton instead.
 */
export function Icon({ name, size = 'md', className }: IconProps) {
  const style = { '--icon-size': `var(--size-icon-${size})` } as CSSProperties
  return (
    <span className={['icon', className].filter(Boolean).join(' ')} style={style} aria-hidden="true">
      {name}
    </span>
  )
}
