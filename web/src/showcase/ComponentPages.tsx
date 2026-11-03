import { useState } from 'react'
import {
  Accordion,
  Badge,
  Button,
  Checkbox,
  CheckboxGroup,
  IconButton,
  ImageCard,
  Input,
  Radio,
  RadioGroup,
  Toggle,
} from '@/components'
import { useI18n } from '@/i18n/i18n'
import { ShowcasePage, ShowcaseSection } from './Showcase'

const buttonTypes = ['primary', 'secondary', 'tertiary', 'alert'] as const
const badgeTypes = ['brand', 'info', 'success', 'warning', 'error', 'promote'] as const

export function AccordionPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.accordion')}>
      <div className="showcase__stack">
        <Accordion title={t('accordion.whatIsThis')} defaultExpanded>
          {t('accordion.contentSlot')}
        </Accordion>
        <Accordion title={t('accordion.collapsed')}>{t('accordion.hidden')}</Accordion>
        <Accordion title={t('accordion.disabled')} disabled>
          {t('accordion.neverShown')}
        </Accordion>
      </div>
    </ShowcasePage>
  )
}

export function BadgePage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.badge')}>
      {(['solid', 'subtle'] as const).map((s) => (
        <ShowcaseSection key={s} title={t(`badge.${s}`)}>
          <div className="showcase__row">
            {badgeTypes.map((bt) => (
              <Badge key={bt} type={bt} badgeStyle={s}>
                {t(`badge.${bt}`)}
              </Badge>
            ))}
            <Badge badgeStyle={s} size="small" icon="star">
              {t('small')}
            </Badge>
          </div>
        </ShowcaseSection>
      ))}
    </ShowcasePage>
  )
}

export function ButtonPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.button')}>
      {(['large', 'small'] as const).map((size) => (
        <ShowcaseSection key={size} title={t(`size.${size}`)} note={t(`button.${size}Note`)}>
          {buttonTypes.map((v) => (
            <div className="showcase__row" key={v}>
              <Button variant={v} size={size}>
                {t(`button.${v}`)}
              </Button>
              <Button variant={v} size={size} disabled>
                {t(`button.${v}`)}
              </Button>
            </div>
          ))}
        </ShowcaseSection>
      ))}
      <ShowcaseSection title={t('withIcons')} note={t('button.iconsNote')}>
        <div className="showcase__row">
          <Button leadingIcon="add">{t('withIcons')}</Button>
          <Button variant="secondary" trailingIcon="chevron_right">
            {t('withIcons')}
          </Button>
        </div>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function CheckboxPage() {
  const { t } = useI18n()
  const channelValues = ['email', 'sms', 'push'] as const
  const [channels, setChannels] = useState<string[]>(['email'])
  return (
    <ShowcasePage title={t('section.checkbox')}>
      <ShowcaseSection title={t('showcase.states')}>
        <div className="showcase__row">
          <Checkbox label={t('checkbox.unchecked')} />
          <Checkbox label={t('checkbox.checked')} defaultChecked />
          <Checkbox label={t('checkbox.indeterminate')} indeterminate />
          <Checkbox label={t('checkbox.disabled')} disabled />
          <Checkbox label={t('checkbox.disabledChecked')} disabled defaultChecked />
          <Checkbox label={t('checkbox.error')} invalid />
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('showcase.group')}>
        <div className="showcase__stack">
          <Checkbox
            label={t('checkboxGroup.selectAll')}
            checked={channels.length === channelValues.length}
            indeterminate={channels.length > 0 && channels.length < channelValues.length}
            onChange={(e) => setChannels(e.target.checked ? [...channelValues] : [])}
          />
          <CheckboxGroup
            legend={t('checkboxGroup.legend')}
            helper={t('checkboxGroup.helper')}
            value={channels}
            onValueChange={setChannels}
            options={channelValues.map((v) => ({ value: v, label: t(`checkboxGroup.${v}`) }))}
          />
        </div>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function IconButtonPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.iconButton')}>
      <ShowcaseSection title={t('size.large')}>
        <div className="showcase__row">
          {buttonTypes.map((v) => (
            <IconButton key={v} variant={v} icon="add" aria-label={t('addVariant', { variant: t(`button.${v}`) })} />
          ))}
          <IconButton icon="add" aria-label={t('addDisabled')} disabled />
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('size.small')}>
        <div className="showcase__row">
          {buttonTypes.map((v) => (
            <IconButton
              key={v}
              variant={v}
              size="small"
              icon="close"
              aria-label={t('closeVariant', { variant: t(`button.${v}`) })}
            />
          ))}
        </div>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function ImageCardPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.imageCard')}>
      {(['vertical', 'horizontal'] as const).map((orientation) => (
        <ShowcaseSection key={orientation} title={t(`card.${orientation}`)}>
          <ImageCard
            orientation={orientation}
            badge={
              <Badge size="small" badgeStyle="subtle">
                {t('card.badge')}
              </Badge>
            }
            title={t('card.title')}
            description={t('card.description')}
            actions={<Button size="small">{t('card.button')}</Button>}
          />
        </ShowcaseSection>
      ))}
    </ShowcasePage>
  )
}

export function InputPage() {
  const { t, language } = useI18n()
  return (
    <ShowcasePage title={t('section.input')}>
      <div className="showcase__row showcase__row--top">
        <Input label={t('input.label')} helper={t('input.helper')} placeholder={t('input.placeholder')} leadingIcon="search" />
        {/* Re-mount on language change so the sample value is translated too. */}
        <Input
          key={language}
          label={t('input.withAction')}
          helper={t('input.clearable')}
          defaultValue={t('input.someValue')}
          trailingAction={<IconButton variant="tertiary" size="small" iconSize="md" icon="close" aria-label={t('input.clear')} />}
        />
        <Input label={t('input.error')} helper={t('input.required')} invalid size="large" placeholder={t('input.placeholder')} />
        <Input label={t('input.disabled')} helper={t('input.notEditable')} disabled placeholder={t('input.placeholder')} />
      </div>
    </ShowcasePage>
  )
}

export function RadioPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.radio')}>
      <div className="showcase__row showcase__row--top">
        <RadioGroup
          legend={t('radioGroup.legend')}
          helper={t('radioGroup.helper')}
          defaultValue="standard"
          options={[
            { value: 'standard', label: t('radioGroup.standard') },
            { value: 'express', label: t('radioGroup.express') },
            { value: 'pickup', label: t('radioGroup.pickup') },
            { value: 'drone', label: t('radioGroup.unavailable'), disabled: true },
          ]}
        />
        <RadioGroup
          legend={t('radioGroup.error')}
          helper={t('radioGroup.errorHelper')}
          invalid
          required
          orientation="horizontal"
          options={[
            { value: 'standard', label: t('radioGroup.standard') },
            { value: 'express', label: t('radioGroup.express') },
          ]}
        />
        <Radio name="single-demo" label={t('checkbox.disabled')} disabled />
      </div>
    </ShowcasePage>
  )
}

export function TogglePage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.toggle')}>
      <div className="showcase__row">
        <Toggle label={t('toggle.off')} />
        <Toggle label={t('toggle.on')} defaultChecked />
        <Toggle label={t('toggle.disabledOff')} disabled />
        <Toggle label={t('toggle.disabledOn')} disabled defaultChecked />
      </div>
    </ShowcasePage>
  )
}
