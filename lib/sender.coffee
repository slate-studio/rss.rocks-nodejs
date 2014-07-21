
Postmark = require("postmark")(process.env.POSTMARK_API_KEY)

module.exports = class Sender
  constructor: (@users, feedsAndPostsToSend, callback) ->
    emails = @generateEmails(feedsAndPostsToSend)

    if emails.length > 0
      @sendEmails(emails, callback)
    else
      console.log 'no emails to send'
      callback()

  sendEmails: (emails, callback) ->
    onSent = _after emails.length, -> console.log "#{emails.length} emails sent" ; callback()

    emails.map (e) ->
      # opts = { "From": e.fromEmail, "To": e.toEmail, "Subject": e.subject, "TextBody": e.body }
      # Postmark.send opts, (error, success) ->
      #   if error then console.error("Unable to send via postmark: " + error.message)
      #   onSent()
      onSent()

  generateEmails: (feeds) ->
    emails = []
    for uid, profile of @users
      do (uid, profile) ->
        for id, s of profile.subscriptions
          do (id, s) ->
            posts = feeds[s.url]
            if posts
              emls = for p in posts
                { fromEmail: '', toEmail: profile.email, subject: s.name, body: "#{p.title}\n#{p.link}" }
              Array::push.apply(emails, emls)
    return emails
