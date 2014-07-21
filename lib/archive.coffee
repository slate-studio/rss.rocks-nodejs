module.exports = class Archive
  constructor: (firebaseRef, feedsAndPosts, @onArchivedCallback) ->
    console.log 'archived'
    @onArchivedCallback()
