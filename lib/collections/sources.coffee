@Sources = new Mongo.Collection 'sources'

@source_types = ->
  [{_id: 'sonar', title: 'Sonar'},
   {_id: 'jenkins', title: 'Jenkins'},
   {_id: 'jira', title: 'Jira'}]

@source_data_types = ->
  sonar: [{_id: 'dashboard', title: 'Dashboard'}]
  jenkins: [{_id: 'test_report', title: 'Test report'}]
  jira: [{_id: 'open_bugs_query', title: 'Open bugs query'}]

Sources.allow
  update: (userId, source) -> ownsProjectItem userId, source
  remove: (userId, source) -> ownsProjectItem userId, source

Sources.deny
  remove: (userId, source) -> SubjectSourceIds.find({source: source._id}).count() > 0

Meteor.methods
  sourceInsert: (sourceAttributes) ->
    check this.userId, String
    validateSource sourceAttributes
    user = Meteor.user()
    source = _.extend sourceAttributes,
      userId: user._id
      submitted: new Date()
      position: 0
      kind: 'source'
    # Update the positions of the existing sources
    Sources.update({_id: s._id}, {$set: {position: s.position+1}}) for s in Sources.find({projectId: source.projectId}).fetch()
    # Create the source, save the id
    source._id = Sources.insert source
    # Now create a notification, informing the project members a source has been added
    project = Projects.findOne source.projectId
    text = user.username + ' added source ' + source.title + ' to ' + project.title
    createNotification(member, user._id, source.projectId, text) for member in project.members
    return source._id
