import { useEffect, useState } from 'react'
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
import { languageNames, languages, useI18n } from '@/i18n/i18n'
import type { Language } from '@/i18n/i18n'
import './App.css'

const themes = ['light', 'dark', 'eva', 'heritage-luxury'] as const
const densities = ['compact', 'default', 'loose'] as const
const buttonTypes = ['primary', 'secondary', 'tertiary', 'alert'] as const
const badgeTypes = ['brand', 'info', 'success', 'warning', 'error', 'promote'] as const

function App() {
  const { t, language, setLanguage } = useI18n()
  const [theme, setTheme] = useState<(typeof themes)[number]>('light')
  const [density, setDensity] = useState<(typeof densities)[number]>('default')
  const [channels, setChannels] = useState<string[]>(['email'])
  const channelValues = ['email', 'sms', 'push'] as const

  useEffect(() => {
    document.documentElement.dataset.theme = theme
    document.documentElement.dataset.density = density
  }, [theme, density])

  return (
    <main className="showcase">
      <header className="showcase__header">
        <h1>{t('appTitle')}</h1>
        <div className="showcase__controls">
          <label className="text-body-2">
            {t('language')}{' '}
            <select id="language" name="language" value={language} onChange={(e) => setLanguage(e.target.value as Language)}>
              {languages.map((l) => (
                <option key={l} value={l} lang={l}>
                  {languageNames[l]}
                </option>
              ))}
            </select>
          </label>
          <label className="text-body-2">
            {t('theme')}{' '}
            <select id="theme" name="theme" value={theme} onChange={(e) => setTheme(e.target.value as typeof theme)}>
              {themes.map((th) => (
                <option key={th} value={th}>
                  {t(`theme.${th}`)}
                </option>
              ))}
            </select>
          </label>
          <label className="text-body-2">
            {t('density')}{' '}
            <select id="density" name="density" value={density} onChange={(e) => setDensity(e.target.value as typeof density)}>
              {densities.map((d) => (
                <option key={d} value={d}>
                  {t(`density.${d}`)}
                </option>
              ))}
            </select>
          </label>
        </div>
      </header>

      <section>
        <h2>{t('section.button')}</h2>
        {(['large', 'small'] as const).map((size) => (
          <div className="showcase__row" key={size}>
            {buttonTypes.map((v) => (
              <Button key={v} variant={v} size={size}>
                {t(`button.${v}`)}
              </Button>
            ))}
            {buttonTypes.map((v) => (
              <Button key={`${v}-d`} variant={v} size={size} disabled>
                {t(`button.${v}`)}
              </Button>
            ))}
            <Button size={size} leadingIcon="add" trailingIcon="chevron_right">
              {t('withIcons')}
            </Button>
          </div>
        ))}
      </section>

      <section>
        <h2>{t('section.iconButton')}</h2>
        <div className="showcase__row">
          {buttonTypes.map((v) => (
            <IconButton key={v} variant={v} icon="add" aria-label={t('addVariant', { variant: t(`button.${v}`) })} />
          ))}
          {buttonTypes.map((v) => (
            <IconButton
              key={`${v}-s`}
              variant={v}
              size="small"
              icon="close"
              aria-label={t('closeVariant', { variant: t(`button.${v}`) })}
            />
          ))}
          <IconButton icon="add" aria-label={t('addDisabled')} disabled />
        </div>
      </section>

      <section>
        <h2>{t('section.badge')}</h2>
        {(['solid', 'subtle'] as const).map((s) => (
          <div className="showcase__row" key={s}>
            {badgeTypes.map((bt) => (
              <Badge key={bt} type={bt} badgeStyle={s}>
                {t(`badge.${bt}`)}
              </Badge>
            ))}
            <Badge badgeStyle={s} size="small" icon="star">
              {t('small')}
            </Badge>
          </div>
        ))}
      </section>

      <section>
        <h2>{t('section.input')}</h2>
        <div className="showcase__row showcase__row--top">
          <Input label={t('input.label')} helper={t('input.helper')} placeholder={t('input.placeholder')} leadingIcon="search" />
          {/* Re-mount on language change so the sample value is translated too. */}
          <Input
            key={language}
            label={t('input.withAction')}
            helper={t('input.clearable')}
            defaultValue={t('input.someValue')}
            trailingAction={
              <IconButton variant="tertiary" size="small" iconSize="md" icon="close" aria-label={t('input.clear')} />
            }
          />
          <Input
            label={t('input.error')}
            helper={t('input.required')}
            invalid
            size="large"
            placeholder={t('input.placeholder')}
          />
          <Input label={t('input.disabled')} helper={t('input.notEditable')} disabled placeholder={t('input.placeholder')} />
        </div>
      </section>

      <section>
        <h2>{t('section.toggle')}</h2>
        <div className="showcase__row">
          <Toggle label={t('toggle.off')} />
          <Toggle label={t('toggle.on')} defaultChecked />
          <Toggle label={t('toggle.disabledOff')} disabled />
          <Toggle label={t('toggle.disabledOn')} disabled defaultChecked />
        </div>
      </section>

      <section>
        <h2>{t('section.checkbox')}</h2>
        <div className="showcase__row">
          <Checkbox label={t('checkbox.unchecked')} />
          <Checkbox label={t('checkbox.checked')} defaultChecked />
          <Checkbox label={t('checkbox.indeterminate')} indeterminate />
          <Checkbox label={t('checkbox.disabled')} disabled />
          <Checkbox label={t('checkbox.disabledChecked')} disabled defaultChecked />
          <Checkbox label={t('checkbox.error')} invalid />
        </div>
        <div className="showcase__row showcase__row--top">
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
        </div>
      </section>

      <section>
        <h2>{t('section.radio')}</h2>
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
      </section>

      <section>
        <h2>{t('section.accordion')}</h2>
        <div className="showcase__stack">
          <Accordion title={t('accordion.whatIsThis')} defaultExpanded>
            {t('accordion.contentSlot')}
          </Accordion>
          <Accordion title={t('accordion.collapsed')}>{t('accordion.hidden')}</Accordion>
          <Accordion title={t('accordion.disabled')} disabled>
            {t('accordion.neverShown')}
          </Accordion>
        </div>
      </section>

      <section>
        <h2>{t('section.imageCard')}</h2>
        <div className="showcase__row showcase__row--top">
          {(['vertical', 'horizontal'] as const).map((orientation) => (
            <ImageCard
              key={orientation}
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
          ))}
        </div>
      </section>
    </main>
  )
}

export default App
