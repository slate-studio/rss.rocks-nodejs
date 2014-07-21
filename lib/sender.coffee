module.exports = class Sender
  constructor: (usersRef, feedsAndPostsToSend, @onSentCallback) ->
    console.log 'sent'
    @onSentCallback()