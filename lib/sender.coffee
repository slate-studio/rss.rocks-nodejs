
Postmark = require("postmark")(process.env.POSTMARK_API_KEY)

module.exports = class Sender
  constructor: (usersRef, feedsAndPostsToSend, callback) ->
    @emails = []
    # TODO: generate emails for subscribers

    if @emails.length > 0
      @sendEmails(callback)
    else
      console.log 'no emails to send'
      callback()

  sendEmails: (callback) ->
    onSent = _after @emails.length, -> console.log 'emails sent' ; callback()

    @emails.map (e) ->
      opts = { "From": e.fromEmail, "To": e.toEmail, "Subject": e.subject, "TextBody": e.body }
      Postmark.send opts, (error, success) ->
        if error then console.error("Unable to send via postmark: " + error.message)
        onSent()