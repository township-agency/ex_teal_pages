<template>
  <default-field :field="field">
    <template slot="field">
      <div
        v-for="field in indexedFields"
        :key="field.title"
        class="mb-2"
      >
        <component
          :is="'form-' + inputType"
          :errors="errors"
          :resource-id="resourceId"
          :resource-name="resourceName"
          :field="field"
        />
      </div>
      <p
        v-if="hasError"
        class="my-2 text-danger"
      >
        {{ firstError }}
      </p>
    </template>
  </default-field>
</template>

<script>
import { FormField, HandlesValidationErrors } from 'ex-teal-js';

export default {
  mixins: [ HandlesValidationErrors, FormField ],

  props: {
    resourceId: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      indexedFields: []
    };
  },

  computed: {
    /**
     * Get the input type.
     */
    inputType () {
      return this.field.options.child_component;
    }
  },

  mounted () {
    this.indexedFields = this.value.map(({ content, title }) => {
      return {
        ...this.field,
        component: this.inputType,
        options: this.field.options,
        value: content,
        name: title
      };
    });

    this.field.fill = formData => {
      let nestedFormData = new FormData;
      const data = this.indexedFields.map(field => {
        field.fill(nestedFormData);
        let value = nestedFormData.get(field.attribute);
        return { title: field.name, content: value };
      });
      console.log(data);
      formData.append(this.field.attribute, JSON.stringify(data));
    };
  }
};
</script>
