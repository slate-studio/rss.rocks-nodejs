// worker.js
// example of integration with Firebase

var Firebase = require('firebase');

firebaseAppName = 'rss-rocks'
var firebaseRef = new Firebase('https://'+firebaseAppName+'.firebaseio.com')
var subscriptionsRef = firebaseRef.child('subscriptions')

subscriptionsRef.on('child_added', function(snapshot) {
  console.log(snapshot.val())
});
