Template.urlControl.onCreated ->
  Session.set Template.currentData().control_id, {}

errorMessage = (field) ->
  Session.get(Template.currentData().control_id)[field]

Template.urlControl.helpers
  errorMessage: errorMessage

  errorClass: (field) ->
    if errorMessage(field) then 'has-error' else ''

  translated_kind: ->
    TAPi18n.__ this.kind
