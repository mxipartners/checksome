A `source` is valid if it has a url and is a valid item.

    @validateSource = (source) ->

First, check that the item has the right structure and is a valid item.

      check source, Match.ObjectIncluding
        url: String
      errors = validateItem source

Then, check that a url is present.

      if source.url == ''
        if Meteor.isServer

When running on the server, a missing url is a fatal error.

          throw new Meteor.Error('invalid-source', 'You must add a url to a source')
        else

When running on the client, we will tell the user to provide a url.

          errors.url = TAPi18n.__ "Please provide a url"
      return errors
