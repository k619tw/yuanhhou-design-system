import type { ComponentType } from 'react'
import type { MessageKey } from '@/i18n/messages'
import {
  AccordionPage,
  BadgePage,
  ButtonPage,
  CheckboxPage,
  IconButtonPage,
  ImageCardPage,
  InputPage,
  LinkPage,
  ModalPage,
  RadioPage,
  TogglePage,
} from './ComponentPages'
import { ColorsPage, IconsPage, SpacingPage, TypographyPage } from './FoundationPages'

export interface PageEntry {
  id: string
  title: MessageKey
  Page: ComponentType
}

// Same structure as the iOS DS catalog: Foundations, then Components in alphabetical order.
export const foundationPages: PageEntry[] = [
  { id: 'colors', title: 'page.colors', Page: ColorsPage },
  { id: 'typography', title: 'page.typography', Page: TypographyPage },
  { id: 'spacing', title: 'page.spacing', Page: SpacingPage },
  { id: 'icons', title: 'page.icons', Page: IconsPage },
]

export const componentPages: PageEntry[] = [
  { id: 'accordion', title: 'section.accordion', Page: AccordionPage },
  { id: 'badge', title: 'section.badge', Page: BadgePage },
  { id: 'button', title: 'section.button', Page: ButtonPage },
  { id: 'checkbox', title: 'section.checkbox', Page: CheckboxPage },
  { id: 'icon-button', title: 'section.iconButton', Page: IconButtonPage },
  { id: 'image-card', title: 'section.imageCard', Page: ImageCardPage },
  { id: 'input', title: 'section.input', Page: InputPage },
  { id: 'link', title: 'section.link', Page: LinkPage },
  { id: 'modal', title: 'section.modal', Page: ModalPage },
  { id: 'radio', title: 'section.radio', Page: RadioPage },
  { id: 'toggle', title: 'section.toggle', Page: TogglePage },
]

export function findPage(id: string) {
  return [...foundationPages, ...componentPages].find((page) => page.id === id)
}
