#! /app/vendor/node/bin/node

Job = require('../lib/job');

cron = new Job();
cron.start();