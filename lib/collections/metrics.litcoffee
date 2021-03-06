`Metrics` are attributes that can be measured. For example, size, velocity,
and complexity.

    @Metrics = new Mongo.Collection 'metrics'

Updates of the metrics are allowed when the user is a member of the project.

    Metrics.allow
      update: (userId, metric) -> ownsProjectItem userId, metric
      remove: (userId, metric) -> false

    @metricInsert = (metricAttributes) ->
      validateMetric metricAttributes
      metric = _.extend metricAttributes,
        submitted: new Date()
        position: 0
        kind: 'metric'

Update the positions of the existing metrics

      Metrics.update({_id: m._id}, {$set: {position: m.position+1}}) for m in Metrics.find({projectId: metric.projectId}).fetch()

Create the metric

      metric._id = Metrics.insert metric
      return metric._id

    @createMetrics = (project) ->
      if not Metrics.findOne({projectId: project._id, title: "NCLOC"})
        metricInsert
          projectId: project._id
          title: "NCLOC"
          description: "Size of the software in non-commented lines of code"
          subject_types: ['component', 'application']
          target: 10000
          unit: " NCLOC"
      if not Metrics.findOne({projectId: project._id, title: "Duplication"})
        metricInsert
          projectId: project._id
          title: "Duplication"
          description: "Percentage of the lines of code that are duplicated"
          subject_types: ['component', 'application']
          target: 1
          unit: "%"
      if not Metrics.findOne({projectId: project._id, title: "Test result"})
        metricInsert
          projectId: project._id
          title: "Test result"
          description: "Number of failed or skipped tests"
          subject_types: ['component', 'application']
          target: 0
          unit: " tests skipped or failed"
      if not Metrics.findOne({projectId: project._id, title: "Open bugs"})
        metricInsert
          projectId: project._id
          title: "Open bugs"
          description: "Number of open bugs"
          subject_types: ['application']
          target: 0
          unit: " open bugs"
      if not Metrics.findOne({projectId: project._id, title: "Open security bugs"})
        metricInsert
          projectId: project._id
          title: "Open security bugs"
          description: "Number of open security bugs"
          subject_types: ['application']
          target: 0
          unit: " open security bugs"
