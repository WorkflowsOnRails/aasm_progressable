aasm_progressable
=================

Rails helper to render the progress indicators for simple linear [AASM](https://github.com/aasm/aasm) workflows. It allows users to see steps in a workflow they have completed, which step is in progress, and which steps have not been completed. See the following image for an example.

![Example Screenshot](https://raw.github.com/WorkflowsOnRails/aasm_progressable/master/docs/sample-screenshot.png)


Using aasm_progressable
-----------------------

Add `aasm_progressable` to your Gemfile, and run bundler to install it. For each model with an appropriate workflow, include `AasmProgressable::ModelMixin`, and add a call to `aasm_state_order` with an array of symbols corresponding to
the expected order in which the states will be traversed. For example, if we have an `Order` class that starts from the `new` state, proceeds to `processing`, and then `shipping`, we might have

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

In order to render the progress indicator, we need to add `helper AasmProgressable::Helper` to your ApplicationController. Then, in any detailed views for the order (such as orders#show), we can add `<%= render_state_indicator the_model_instance %>` to render an indicator for the state of the specified instance of the model. By default, this will render an ordered list (`ol`) with one element per state, with the elements corresponding to complete, current, and incomplete states being classed with `complete`, `active`, and `incomplete` respectively. You can add a ` *= require aasm_progressable` line to your application stylesheet to include some default styling for the indicator.


Customizing and Localizing aasm_progressable
--------------------------------------------

aasm_progressable uses `AASM::Localizer#human_state_name` to convert AASM states to output text. By default, this method will replace underscores with spaces, and capitalize the first letter of the state name. However, it can also fetch state names from a locale key of the form `activerecord.attributes.<model-table-name>.<aasm-column-name>/<state-symbol>`. By default, `<aasm-column-name>` will be "aasm_state".

As an example, if we wanted to display "Unconfirmed" as English name for the `:new` order state in the previous example, we could add the following to config/locales/en.yml:

```yaml
en:
  activerecord:
    attributes:
      order:
        aasm_state/new: "Unconfirmed"
```


Limitations
------------

Models that use aasm_progressable should have a strictly linear workflow, ie. there should be no branches in the state machine. Loops and skipped states are permitted, but there may not be alternative states. If a model instance is in a state that does not appear in the model's `aasm_state_order` declaration, then the helper will not be able to infer the state transition history of the instance and all states will be rendered as if they were completed.
