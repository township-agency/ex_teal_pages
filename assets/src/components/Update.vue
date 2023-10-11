<template>
  <div v-if="!loading">
    <div class="card-headline">
      <heading class="">
        Editing {{ title }}
      </heading>
      <div class="flex ml-auto">
        <button
          class="ml-auto btn btn-default btn-secondary mr-3"
          @click="updateResource"
        >
          Save &amp; Close
        </button>

        <button
          type="button"
          class="btn btn-default btn-primary capitalize"
          @click="updateAndContinueEditing"
        >
          Save {{ singularName }}
        </button>
      </div>
    </div>

    <form
      v-if="fields"
      @submit.prevent="updateResource"
    >
      <!-- Validation Errors -->
      <validation-errors :errors="validationErrors" />

      <form-panel
        v-for="(panel, index) in panelsWithFields"
        :key="panel.name"
        class="mb-6"
        :index="index"
        :panel="panel"
        :name="panel.name"
        :fields="panel.fields"
        :validation-errors="validationErrors"
        :resource-name="resourceName"
      />
    </form>
  </div>
</template>

<script>
import _ from 'lodash';
import tap from 'lodash/tap';
import each from 'lodash/each';
import { Errors } from 'ex-teal-js';

export default {
  props: {
    pageKey: {
      type: String,
      required: true
    }
  },

  data: () => ({
    loading: true,
    fields: [],
    validationErrors: new Errors(),
    panels: [],
    title: ''
  }),

  computed: {
    /**
     * Create the form data for creating the resource.
     */
    updateResourceFormData () {
      return tap(new FormData(), formData => {
        each(this.fields, field => {
          field.fill(formData);
        });
      });
    },

    panelsWithFields () {
      return _.map(this.panels, panel => {
        return {
          ...panel,
          fields: _.filter(this.fields, field => {
            return field.panel === panel.key;
          })
        };
      });
    }
  },

  created () {
    this.getFields();
  },

  methods: {
    /**
     * Get the available fields for the resource.
     */
    async getFields () {
      this.loading = true;

      this.fields = [];

      const {
        data: { fields, panels, title }
      } = await ExTeal.request()
        .get(`/plugins/pages/${this.pageKey}/update-fields`)
        .catch(error => {
          if (error.response && error.response.status == 404) {
            this.$router.push({ name: '404' });
            return;
          }
        });

      this.fields = fields;
      this.panels = panels;
      this.title = title;

      this.loading = false;
    },

    /**
     * Update the resource using the provided data.
     */
    async updateResource () {
      try {
        await this.updateRequest();

        this.$toasted.show(`The ${this.title} was updated`, {
          type: 'success'
        });

        this.$router.push({
          name: 'page_detail',
          params: {
            pageKey: this.pageKey
          }
        });
      } catch (error) {
        if (error.response && error.response.status == 422) {
          this.validationErrors = new Errors(error.response.data.errors);
        }
      }
    },

    /**
     * Update the resource and reset the form
     */
    async updateAndContinueEditing () {
      try {
        await this.updateRequest();

        this.$toasted.show(`The ${this.title} was updated!`, {
          type: 'success'
        });

        // Reset the form by refetching the fields
        this.getFields();
      } catch (error) {
        if (error.response && error.response.status == 422) {
          this.validationErrors = new Errors(error.response.data.errors);
        }
      }
    },

    /**
     * Send an update request for this resource
     */
    updateRequest () {
      return ExTeal.request().put(
        `/plugins/pages/${this.pageKey}`,
        this.updateResourceFormData
      );
    },

    /**
     * Update the last retrieved at timestamp to the current UNIX timestamp.
     */
    updateLastRetrievedAtTimestamp () {
      this.lastRetrievedAt = Math.floor(new Date().getTime() / 1000);
    }
  }
};
</script>
