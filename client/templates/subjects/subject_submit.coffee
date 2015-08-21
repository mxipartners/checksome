Template.subjectSubmit.helpers  
  has_subjects: -> Subjects.find().count() > 0


Template.subjectSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $title = $(e.target).find '[name=title]'
    $description = $(e.target).find '[name=description]'
    subject =
      title: $title.val()
      description: $description.val()
      projectId: template.data._id

    Session.set 'subject_title', {}
    errors = validateSubject subject
    if errors.title
      Session.set 'subject_title', errors
      return false

    Meteor.call 'subjectInsert', subject, (error, subjectId) ->
      if error
        throwError error.reason
      else
        $title.val('')
        $description.val('')

  'click .cancel': (e) -> stop_submitting()