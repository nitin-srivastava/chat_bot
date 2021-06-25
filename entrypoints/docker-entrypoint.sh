#!/bin/sh

set -e
if [ -f db/development.sqlite3 ]; then
    bundle exec rake db:migrate
else
   bundle exec rake db:setup db:migrate
fi

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0