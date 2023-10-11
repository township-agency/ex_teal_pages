import Nav from './components/Nav.vue';
import ArrayPanel from './components/ArrayPanel.vue';
import FormPagesArray from './components/FormPagesArray.vue';
import ResourceField from './components/ResourceField.vue';
import Detail from './components/Detail.vue';
import Update from './components/Update.vue';

ExTeal.booting((Vue, router) => {
  Vue.component('pages-nav', Nav);
  Vue.component('pages-array-panel', ArrayPanel);
  Vue.component('form-pages-array', FormPagesArray);
  Vue.component('detail-resource-field', ResourceField);

  router.addRoutes([
    {
      path: '/pages/:pageKey',
      name: 'page_detail',
      component: Detail,
      props: route => {
        return {
          pageKey: route.params.pageKey
        };
      }

    },
    {
      path: '/pages/:pageKey/edit',
      name: 'page_edit',
      component: Update,
      props: route => {
        return {
          pageKey: route.params.pageKey
        };
      }
    },
  ]);
});
