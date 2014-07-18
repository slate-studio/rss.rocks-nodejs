# RSS.Rocks! Node.js Backend

Heroku setup: https://devcenter.heroku.com/articles/getting-started-with-nodejs

### web.js

Implements information interface/admin for the app. Custom paths and handlers are not required, cause all data logic can be implemented on frontend side same way as on node.js backend. So this just enables public folder for static HTML+JS+CSS app.

Application custom APIs should be implemented here.

### worker.js

This makes possible backend callbacks of Firebase, that can help to implement some data logic and data optimization/organization. This might be very helpful consider Firebase limits.

### bin/cron.js

Backend scheduled tasks.

## Sending Mail with Postmark

https://devcenter.heroku.com/articles/postmark#sending-emails-in-nodejs

## Node Hosting

https://github.com/joyent/node/wiki/Node-Hosting