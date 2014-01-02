- Log an error when an unexpected state is encountered when rendering
  a progress indicator.

- Validate that all states are in the state order declaration, and that
  all states in the state order declaration are valid states.

- Infer the state order from the model's AASM instance. (Essentially,
  if there is a total order on the model's states based on event transitions
  then we have a state order; otherwise, the workflow is non-linear.)

- Add a generator to install a template to override the view and stylesheet.
