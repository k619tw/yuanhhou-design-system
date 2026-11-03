import { Icon } from '@yuanhhou/ds'
import { useI18n } from '@/i18n/i18n'
import { componentPages, foundationPages } from './pages'
import type { PageEntry } from './pages'
import { pageHref } from './router'

function CatalogGroup({ id, title, pages }: { id: string; title: string; pages: PageEntry[] }) {
  const { t } = useI18n()
  return (
    <section className="catalog__group" aria-labelledby={id}>
      <h2 id={id} className="catalog__heading text-body-2 text-emphasized">
        {title}
      </h2>
      <ul className="catalog__list">
        {pages.map((page) => (
          <li className="catalog__item" key={page.id}>
            <a className="catalog__link" href={pageHref(page.id)}>
              <span className="catalog__title text-body-1">{t(page.title)}</span>
              <Icon name="chevron_right" size="md" />
            </a>
          </li>
        ))}
      </ul>
    </section>
  )
}

/** Home of the demo: every foundation and component page (iOS: `DesignSystemCatalogView`). */
export function Catalog() {
  const { t } = useI18n()
  return (
    <div className="catalog">
      <CatalogGroup id="catalog-foundations" title={t('catalog.foundations')} pages={foundationPages} />
      <div className="catalog__group">
        <CatalogGroup id="catalog-components" title={t('catalog.components')} pages={componentPages} />
        <p className="catalog__footer text-caption-1">{t('catalog.footer')}</p>
      </div>
    </div>
  )
}
