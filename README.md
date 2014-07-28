# rss.rocks 

Node.js Backend.

Heroku setup: https://devcenter.heroku.com/articles/getting-started-with-nodejs

### bin/cron.js

Backend scheduled tasks. This pulls all feeds and checks if new posts are published. Delivers all new posts to subscribed users.

## Sending mail with Postmark

https://devcenter.heroku.com/articles/postmark#sending-emails-in-nodejs

## Node Hosting

https://github.com/joyent/node/wiki/Node-Hosting

# TODO:

* add lock for cron job
* add security rules for firebase
* add remove account feature
* finish reset password feature
