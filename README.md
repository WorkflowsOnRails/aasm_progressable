aasm_progressable
=================

`aasm_progressable` is a Rails helper to render the progress indicators for simple linear [AASM](https://github.com/aasm/aasm) workflows. It also provides predicates to make it easy to check a model's current position in its workflow. Using `aasm_progressable` allows users to see steps in a workflow they have completed, which step is in progress, and which steps have not been completed. See the following image for an example.

![Example Screenshot](https://raw.github.com/WorkflowsOnRails/aasm_progressable/master/docs/sample-screenshot.png)


Usage
-----

Add `aasm_progressable` to your Gemfile, and run bundler to install it. For each model with an appropriate workflow, include `AasmProgressable::ModelMixin`, and add a call to `aasm_state_order` with an array of symbols corresponding to
the expected order in which the states will be traversed. For example, if you have an `Order` class that starts from the `new` state, proceeds to `processing`, and then `shipping`, you might have

```rb
class Order < ActiveRecord::Base
  include AASM
  aasm do
    state :new, initial: true
    state :processing
    state :shipping
    
    event :confirm do
      transitions from: :new, to: :processing
    end
    event :dispatch do
      transitions from: :processing, to: :shipping
    end
  end
  
  aasm_state_order [:new, :processing, :shipping]
end
```

In order to render the progress indicator, you need to add `helper AasmProgressable::Helper` to your ApplicationController. Then in any detailed views for the order (such as `orders#show`), add `<%= render_state_indicator the_model_instance %>` to render an indicator for the state of the specified instance of the model. By default, this will render an ordered list (`ol`) with one element per state, with the elements corresponding to complete, current, and incomplete states being classed with `complete`, `active`, and `incomplete` respectively. You can add a ` *= require aasm_progressable` line to your application stylesheet to include some default styling for the indicator.


Custom Rendering
---------------------

The default template for `aasm_progressable` can be customized to suit your needs. Run `rails g aasm_progressable:views` to copy the default template to app/views/aasm\_progressable/states/\_list.html.erb, and edit it as needed.

If you need additional template variables, you can pass local variables to the invocation of `render_state_indicator`. For instance, you can do the following to make the model instance available in a local variable:
```erb
<%= render_state_indicator the_model_instance, locals: {object: the_model_instance } %>
```

Localization
------------

`aasm_progressable `uses `AASM::Localizer#human_state_name` to convert AASM states to output text. By default, this method will replace underscores with spaces, and capitalize the first letter of the state name. However, it can also fetch state names from a locale key of the form `activerecord.attributes.<model-table-name>.<aasm-column-name>/<state-symbol>`. By default, `<aasm-column-name>` will be "aasm_state".

As an example, if we wanted to display "Unconfirmed" as English name for the `:new` order state in the previous example, we could add the following to config/locales/en.yml:

```yaml
en:
  activerecord:
    attributes:
      order:
        aasm_state/new: "Unconfirmed"
```


State Predicates
----------------

`aasm_progressable` also provides a few predicates that you can use to query a model's state:

- `#have_completed?` and `#have_not_completed?` can be used to check if a step has already been finished. In the Order example, if the current state of an instance named `order` was `processing`, then `order.have_completed? :new` would return true, while `order.have_completed? :processing` would return false.

- `#have_started?` and `#have_not_started?` can be used to check if a step has already started. Again using the Order model defined previously, if an instance named `order` was in the `processing` state, then `order.have_started? :processing` would be true, while `order.have_not_started? :shipping` would return false.

Limitations
------------

Models that use `aasm_progressable` should have a strictly linear workflow, ie. there should be no branches in the state machine. Loops and skipped states are permitted, but there may not be alternative states. If a model instance is in a state that does not appear in the model's `aasm_state_order` declaration, then the helper will not be able to infer the state transition history of the instance and all states will be rendered as if they were completed.
