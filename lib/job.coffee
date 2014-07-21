
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Parser   = require('./parser')
Archive  = require('./archive')
Sender   = require('./sender')
Firebase = require('firebase')

module.exports = class Job
  constructor: ->
    @firebaseAppName = 'rss-rocks'
    @firebaseRef     = new Firebase("https://#{@firebaseAppName}.firebaseio.com")
    @usersRef        = @firebaseRef.child('users')

  start: ->
    @usersRef.on 'value', (snapshot) =>
      @usersRef.off()
      @users = snapshot.val()

      @pullFeedsOutOfSubscriptions()
      @sendEmailsWithNewPosts()

  pullFeedsOutOfSubscriptions: ->
    # TODO: this can be handle by backend helper that saves unique feeds collection
    #       while user adds subscription.
    feeds = []
    for uid, profile of @users
      do (uid, profile) ->
        urls = for id, s of profile.subscriptions
          s.url
        Array::push.apply(feeds, urls)

    @feeds = feeds.unique()

  sendEmailsWithNewPosts: ->
    # fetch feeds urls and collect all published posts
    new Parser @feeds, (feedsAndPosts) =>
      # collect new posts and archive them
      new Archive @firebaseRef, feedsAndPosts, (feedsAndNewPosts) =>
        # send email with new posts to subscribers
        new Sender @usersRef, feedsAndNewPosts, ->
          console.log 'done'
          process.exit()
