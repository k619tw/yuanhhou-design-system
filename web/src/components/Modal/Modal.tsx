import { useEffect, useId, useLayoutEffect, useRef } from 'react'
import type { ReactNode } from 'react'
import { IconButton } from '../IconButton/IconButton'
import './Modal.css'

export interface ModalProps {
  /** Controlled: the modal shows while `open` is true. */
  open: boolean
  /**
   * Called when the person asks to close it: the close button, Escape, or a click on the backdrop.
   * Set `open` to false here; the modal does not close itself.
   */
  onClose: () => void
  /** Figma `Title`. Rendered as an `h2` and used as the dialog's accessible name. */
  title: ReactNode
  /** Figma `Description` (`Show description`). Read out with the title when the modal opens. */
  description?: ReactNode
  /** Figma `Content` slot: a form, a list, any content. */
  children?: ReactNode
  /** Figma `Actions` (`Show actions`): one or two Buttons, the primary last. */
  actions?: ReactNode
  /**
   * Accessible name of the close Icon Button (`Show close button`). Pass a translated "Close".
   * Leave it out to hide the button: then the modal is closed with an action or Escape.
   */
  closeLabel?: string
  /** A click on the backdrop calls `onClose`. Turn off when closing would lose what the person typed. */
  dismissOnBackdrop?: boolean
  className?: string
}

/**
 * A modal dialog built on the native `<dialog>` element and `showModal()`, so the browser provides the
 * focus trap, the inert page behind it, Escape and the top layer. Focus moves to the first focusable
 * element inside (add `autoFocus` to choose another) and returns to the opener when it closes.
 * iOS has no DS modal: use the native `.sheet` (see docs/ios.md).
 */
export function Modal({
  open,
  onClose,
  title,
  description,
  children,
  actions,
  closeLabel,
  dismissOnBackdrop = true,
  className,
}: ModalProps) {
  const ref = useRef<HTMLDialogElement>(null)
  // The latest onClose, for the native listener and handlers, without re-adding the listener each render.
  const onCloseRef = useRef(onClose)
  useLayoutEffect(() => {
    onCloseRef.current = onClose
  })
  const id = useId()

  useEffect(() => {
    const dialog = ref.current
    if (!dialog) return
    if (open && !dialog.open) dialog.showModal()
    else if (!open && dialog.open) dialog.close()
  }, [open])

  // Escape fires `cancel`. Keep the dialog open and let the owner decide, so `open` stays the only source of truth.
  useEffect(() => {
    const dialog = ref.current
    if (!dialog) return
    const cancel = (event: Event) => {
      event.preventDefault()
      onCloseRef.current()
    }
    dialog.addEventListener('cancel', cancel)
    return () => dialog.removeEventListener('cancel', cancel)
  }, [])

  const classes = ['modal', className].filter(Boolean).join(' ')
  return (
    <dialog
      ref={ref}
      className={classes}
      aria-labelledby={`${id}-title`}
      aria-describedby={description ? `${id}-description` : undefined}
      onClick={(event) => {
        // A click whose target is the dialog itself landed on the backdrop: the content fills the box.
        if (dismissOnBackdrop && event.target === ref.current) onCloseRef.current()
      }}
    >
      <div className="modal__surface">
        <div className="modal__header">
          <div className="modal__text">
            <h2 id={`${id}-title`} className="modal__title text-title-3 text-emphasized">
              {title}
            </h2>
            {description && (
              <p id={`${id}-description`} className="modal__description text-body-1">
                {description}
              </p>
            )}
          </div>
          {closeLabel && (
            <IconButton
              className="modal__close"
              icon="close"
              aria-label={closeLabel}
              variant="tertiary"
              size="small"
              iconSize="md"
              onClick={() => onCloseRef.current()}
            />
          )}
        </div>
        {children && <div className="modal__content">{children}</div>}
        {actions && <div className="modal__actions">{actions}</div>}
      </div>
    </dialog>
  )
}
