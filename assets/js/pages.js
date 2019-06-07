ExTeal.booting((Vue, router) => {
  Vue.component('pages-nav', require('./components/Nav').default);
  Vue.component('pages-array-panel', require('./components/ArrayPanel').default);
  Vue.component('form-pages-array', require('./components/FormPagesArray').default);
  Vue.component('detail-resource-field', require('./components/ResourceField').default);

  router.addRoutes([
    {
      path: '/pages/:pageKey',
      name: 'page_detail',
      component: require('./components/Detail').default,
      props: route => {
        return {
          pageKey: route.params.pageKey
        };
      }

    },
    {
      path: '/pages/:pageKey/edit',
      name: 'page_edit',
      component: require('./components/Update').default,
      props: route => {
        return {
          pageKey: route.params.pageKey
        };
      }
    },
  ]);
});
