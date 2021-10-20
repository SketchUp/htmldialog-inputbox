    const KEY_RETURN = 13;
    const KEY_ESC = 27;

    Vue.component('su-textbox', {
      props: ['index', 'controlId', 'input'],
      template: `
        <div>
          <label
              class="col-sm-3 control-label"
              v-bind:for.once="controlId">{{ input.label }}: </label>
          <div class="col-sm-9">
            <input
                class="form-control"
                v-bind:id.once="controlId"
                v-model="input.value"
                v-bind:autofocus.once="index == 0"
                onfocus="this.select()">
          </div>
        </div>
      `
    });

    Vue.component('su-checkbox', {
      props: ['index', 'controlId', 'input'],
      template: `
        <div class="container-fluid">
        <div class="form-check">
          <input
              type="checkbox"
              class="form-check-input"
              v-bind:id.once="controlId"
              v-model="input.value"
              v-bind:autofocus.once="index == 0"
              onfocus="this.select()">
          <label
              class="form-check-label"
              v-bind:for.once="controlId">{{ input.label }}</label>
        </div>
        </div>
      `
    });

    Vue.component('su-listbox', {
      props: ['index', 'controlId', 'input'],
      template: `
        <div>
          <label
              class="col-sm-3 control-label"
              v-bind:for.once="controlId">{{ input.label }}: </label>
          <div class="col-sm-9">
            <select
                class="form-control"
                v-bind:id.once="controlId"
                v-model="input.value"
                v-bind:autofocus.once="index == 0"
                v-bind:size.once="5">
              <option v-for="option in input.options">{{ option }}</option>
            </select>
          </div>
        </div>
      `
    });

    Vue.component('su-dropdown', {
      props: ['index', 'controlId', 'input'],
      template: `
        <div>
          <label
              class="col-sm-3 control-label"
              v-bind:for.once="controlId">{{ input.label }}: </label>
          <div class="col-sm-9">
            <select
                class="form-control"
                v-bind:id.once="controlId"
                v-model="input.value"
                v-bind:autofocus.once="index == 0">
              <option v-for="option in input.options">{{ option }}</option>
            </select>
          </div>
        </div>
      `
    });

    let app = new Vue({
      el: '#app',
      data: {
        options: {
          title: 'Untitled',
          inputs: [],
        },
      },
      methods: {
        accept() {
          let values = this.options.inputs.map((input) => {
            return input.value;
          });
          sketchup.accept(values);
        },
        cancel() {
          sketchup.cancel();
        },
        controlId(index) {
          return `suInputControl${index}`;
        },
        globalKeyup(event) {
          switch (event.keyCode) {
            case KEY_ESC:
              // Dialog 'cancel' is already handled by the html form. Additional handling can be added here.
              break;
            case KEY_RETURN:
              // Dialog 'accept' is already handled by the html form. Additional handling can be added here.
              break;
          }
        }
      },
      mounted: function () {
        // Capture global key events.
        window.addEventListener('keyup', (event) => {
          this.globalKeyup(event);
        });
        // Signal the Ruby side that the dialog is ready to be interacted with.
        sketchup.ready();
      }
    });
