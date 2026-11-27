import { useState } from 'react'
import {
  Accordion,
  Badge,
  Button,
  Card,
  Checkbox,
  CheckboxGroup,
  DescriptionList,
  Icon,
  IconButton,
  ImageCard,
  Input,
  Link,
  Modal,
  Radio,
  RadioGroup,
  SegmentedControl,
  Timeline,
  Toggle,
} from '@yuanhhou/ds'
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
  const badge = (
    <Badge size="small" badgeStyle="subtle">
      {t('card.badge')}
    </Badge>
  )
  return (
    <ShowcasePage title={t('section.imageCard')}>
      {(['vertical', 'horizontal'] as const).map((orientation) => (
        <ShowcaseSection key={orientation} title={t(`card.${orientation}`)}>
          <ImageCard
            orientation={orientation}
            badge={badge}
            title={t('card.title')}
            description={t('card.description')}
            actions={<Button size="small">{t('card.button')}</Button>}
          />
        </ShowcaseSection>
      ))}
      <ShowcaseSection title={t('card.styles')}>
        <div className="showcase__row showcase__row--top">
          {(['elevated', 'outlined', 'filled', 'plain'] as const).map((variant) => (
            <ImageCard key={variant} variant={variant} badge={badge} title={t(`card.${variant}`)} description={t('card.description')} />
          ))}
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('card.sizes')}>
        <div className="showcase__row showcase__row--top">
          {(['medium', 'large'] as const).map((size) => (
            <ImageCard key={size} size={size} badge={badge} title={t(`card.${size}`)} description={t('card.description')} />
          ))}
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('card.linkCard')}>
        <ImageCard
          variant="plain"
          size="large"
          mediaRatio="4 / 3"
          badge={
            <>
              <Badge size="small" badgeStyle="solid">{t('card.badge')}</Badge>
              <Badge size="small">{t('card.badge')}</Badge>
              <Badge size="small">{t('card.badge')}</Badge>
            </>
          }
          title={t('card.title')}
          description={t('card.description')}
          href="#image-card"
          linkLabel={t('card.readMore')}
          linkNote={
            <>
              <Icon name="lock" size="sm" />
              {t('card.note')}
            </>
          }
        />
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function CardPage() {
  const { t } = useI18n()
  const content = (
    <>
      <span className="text-headline text-emphasized">{t('card.sampleTitle')}</span>
      <span className="text-body-2">{t('card.sampleBody')}</span>
    </>
  )
  return (
    <ShowcasePage title={t('section.card')}>
      <ShowcaseSection title={t('card.styles')}>
        <div className="showcase__row showcase__row--top">
          {(['filled', 'outlined', 'elevated'] as const).map((variant) => (
            <Card key={variant} variant={variant} style={{ width: 240 }}>
              <span className="text-caption-1 text-emphasized">{t(`card.${variant}`)}</span>
              {content}
            </Card>
          ))}
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('card.padding')}>
        <div className="showcase__row showcase__row--top">
          {(['default', 'comfortable', 'none'] as const).map((padding) => (
            <Card key={padding} variant="outlined" padding={padding} style={{ width: 240 }}>
              <span className="text-caption-1 text-emphasized">
                {t(`card.padding${padding[0].toUpperCase()}${padding.slice(1)}` as 'card.paddingDefault')}
              </span>
              {content}
            </Card>
          ))}
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('card.onSecondary')}>
        <div className="showcase__row showcase__row--top showcase__band">
          {(['filled', 'outlined', 'elevated'] as const).map((variant) => (
            <Card key={variant} variant={variant} surface="secondary" style={{ width: 240 }}>
              <span className="text-caption-1 text-emphasized">{t(`card.${variant}`)}</span>
              {content}
            </Card>
          ))}
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('card.linkTitle')}>
        <Card href="#card" style={{ width: 320 }}>
          <span className="text-headline text-emphasized">{t('card.linkTitle')}</span>
          <span className="text-body-2">{t('card.linkBody')}</span>
        </Card>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function DescriptionListPage() {
  const { t } = useI18n()
  const items = [
    { term: t('dl.role'), details: t('dl.roleValue') },
    { term: t('dl.company'), details: t('dl.companyValue') },
    { term: t('dl.period'), details: t('dl.periodValue') },
    { term: t('dl.platforms'), details: t('dl.platformsValue') },
  ]
  return (
    <ShowcasePage title={t('section.descriptionList')}>
      <ShowcaseSection title={t('dl.grid')}>
        <DescriptionList items={items} />
      </ShowcaseSection>
      <ShowcaseSection title={t('dl.rows')}>
        <Card padding="none" style={{ maxWidth: 400, paddingInline: 'var(--space-inset-default)' }}>
          <DescriptionList layout="rows" items={items} />
        </Card>
      </ShowcaseSection>
    </ShowcasePage>
  )
}

export function TimelinePage() {
  const { t } = useI18n()
  const milestones = [1, 2, 3].map((n) => ({
    label: t(`timeline.when${n}` as 'timeline.when1'),
    title: t(`timeline.what${n}` as 'timeline.what1'),
  }))
  const roles = [1, 2, 3].map((n) => ({
    title: t(`timeline.role${n}` as 'timeline.role1'),
    description: t(`timeline.org${n}` as 'timeline.org1'),
  }))
  return (
    <ShowcasePage title={t('section.timeline')}>
      <ShowcaseSection title={t('timeline.medium')}>
        <Timeline items={milestones} />
      </ShowcaseSection>
      <ShowcaseSection title={t('timeline.large')}>
        <Timeline size="large" items={roles} />
      </ShowcaseSection>
      <ShowcaseSection title={t('timeline.withFill')}>
        <Timeline items={milestones} progress={0.6} />
      </ShowcaseSection>
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

const linkSizes = [
  { size: 'body-1', key: 'link.body1', text: 'text-body-1' },
  { size: 'body-2', key: 'link.body2', text: 'text-body-2' },
  { size: 'caption-1', key: 'link.caption1', text: 'text-caption-1' },
] as const

export function LinkPage() {
  const { t } = useI18n()
  return (
    <ShowcasePage title={t('section.link')}>
      {linkSizes.map(({ size, key, text }) => (
        <ShowcaseSection key={size} title={t(key)}>
          <p className={text}>
            {t('link.sentenceBefore')}
            <Link href="#/link" size={size}>
              {t('link.inline')}
            </Link>
            {t('link.sentenceAfter')}
          </p>
          <div className="showcase__link-standalone">
            <Link href="#/link" size={size}>
              {t('link.standalone')}
            </Link>
          </div>
        </ShowcaseSection>
      ))}
    </ShowcasePage>
  )
}

export function ModalPage() {
  const { t } = useI18n()
  const [shown, setShown] = useState<'confirm' | 'form' | null>(null)
  const close = () => setShown(null)
  return (
    <ShowcasePage title={t('section.modal')}>
      <ShowcaseSection title={t('modal.confirmTitle')} note={t('modal.confirmNote')}>
        <div className="showcase__row">
          <Button variant="secondary" onClick={() => setShown('confirm')}>
            {t('modal.open')}
          </Button>
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('modal.formTitle')} note={t('modal.formNote')}>
        <div className="showcase__row">
          <Button variant="secondary" onClick={() => setShown('form')}>
            {t('modal.open')}
          </Button>
        </div>
      </ShowcaseSection>
      <p className="showcase-note text-body-2">{t('modal.iosNote')}</p>

      <Modal
        open={shown === 'confirm'}
        onClose={close}
        title={t('modal.discardTitle')}
        description={t('modal.discardBody')}
        closeLabel={t('modal.close')}
        actions={
          <>
            <Button variant="secondary" onClick={close}>
              {t('modal.keep')}
            </Button>
            <Button variant="alert" onClick={close}>
              {t('modal.discard')}
            </Button>
          </>
        }
      />
      <Modal
        open={shown === 'form'}
        onClose={close}
        title={t('modal.renameTitle')}
        description={t('modal.renameBody')}
        closeLabel={t('modal.close')}
        dismissOnBackdrop={false}
        actions={
          <>
            <Button variant="secondary" onClick={close}>
              {t('modal.cancel')}
            </Button>
            <Button onClick={close}>{t('modal.save')}</Button>
          </>
        }
      >
        <Input label={t('modal.nameLabel')} size="large" data-autofocus />
      </Modal>
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

export function SegmentedControlPage() {
  const { t } = useI18n()
  const range = [
    { value: 'day', label: t('segmented.day') },
    { value: 'week', label: t('segmented.week') },
    { value: 'month', label: t('segmented.month') },
  ]
  const view = [
    { value: 'list', label: t('segmented.list') },
    { value: 'grid', label: t('segmented.grid') },
  ]
  return (
    <ShowcasePage title={t('section.segmentedControl')}>
      <ShowcaseSection title={t('size.large')} note={t('segmented.note')}>
        <div className="showcase__row">
          <SegmentedControl label={t('segmented.range')} defaultValue="day" options={range} />
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('size.small')}>
        <div className="showcase__row">
          <SegmentedControl label={t('segmented.view')} size="small" defaultValue="list" options={view} />
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('showcase.states')}>
        <div className="showcase__row">
          <SegmentedControl label={t('segmented.range')} defaultValue="week" options={range} disabled />
          <SegmentedControl
            label={t('segmented.range')}
            defaultValue="day"
            options={range.map((o) => ({ ...o, disabled: o.value === 'month' }))}
          />
        </div>
      </ShowcaseSection>
      <ShowcaseSection title={t('segmented.fullWidth')}>
        <SegmentedControl label={t('segmented.range')} defaultValue="month" options={range} fullWidth />
      </ShowcaseSection>
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
