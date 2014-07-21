module.exports = class Cacher
  constructor: (firebaseRef, feedsAndPosts, @callback) ->
    @archiveRef = firebaseRef.child('archive')
    # TODO: here we need to pull latest posts for each feed
    #       and figure out new ones in feedsAndPosts.

    @feedsAndNewPosts = feedsAndPosts

    @callback(@feedsAndNewPosts)
