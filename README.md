# RSS.Rocks! Node.js Backend

Heroku setup: https://devcenter.heroku.com/articles/getting-started-with-nodejs

### web.js

Implements information interface/admin for the app. In firebase case it is not required, cause all data logic can be implemented on frontend side same way as on node.js backend. So this should be probably replaced with static HTML+JS+CSS app.

This might implement some app specific APIs.

### worker.js

This part of the app could implement backend callbacks of Firebase, that can help to implement some data logic and organization. This might be very helpful with Firebase limitations.

### cron.sh