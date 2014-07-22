
# taken from lodash.js at: https://github.com/lodash/lodash/blob/master/lodash.js
global._after = (n, func) ->
  throw new TypeError(FUNC_ERROR_TEXT) if !(typeof func == 'function' || false)
  n = if typeof n == 'number' && isFinite(n = +n) then n else 0
  return -> func.apply(this, arguments) if --n < 1

# monkey patching to add unique method to array
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Array::appendArray = (array) ->
  Array::push.apply(this, array)

Array::clone = (array) ->
  return this.slice(0)


Parser   = require('./parser')
Cacher   = require('./cacher')
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

      if @feeds.length > 0
        @sendEmailsWithNewPosts()
      else
        console.log 'no subscriptions'
        process.exit()

  pullFeedsOutOfSubscriptions: ->
    # TODO: this can be handle by backend helper that saves unique feeds collection
    #       while user adds subscription.
    feeds = []
    for uid, profile of @users
      do (uid, profile) ->
        urls = (s.url for id, s of profile.subscriptions)
        feeds.appendArray(urls)
    @feeds = feeds.unique()

  sendEmailsWithNewPosts: ->
    # fetch feeds urls and collect all published posts
    new Parser @feeds, (feedsAndPosts) =>
      console.log 'feeds fetched'
      # collect new posts and put newest to the cache
      new Cacher @firebaseRef, feedsAndPosts, (feedsAndNewPosts) =>
        # send email with new posts to subscribers
        new Sender @users, feedsAndNewPosts, ->
          process.exit()
