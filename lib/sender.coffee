
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
    Postmark.batch emails, (error, success) ->
      if error then console.error("Unable to send via postmark: " + error.message)

      console.log "#{emails.length} emails sent"
      callback()

  generateEmails: (feeds) ->
    emails = []
    for uid, profile of @users
      do (uid, profile) ->
        for id, s of profile.subscriptions
          do (id, s) ->
            posts = feeds[s.url]
            if posts
              emls = for p in posts
                { "From": "service@kra.vc", "To": profile.email, "Subject": s.name, "TextBody": "#{p.title}\n#{p.link}" }
              emails.appendArray(emls)
    return emails
