# Watch-Dog

[![Code Climate](https://codeclimate.com/github/vigetlabs/watch-dog.png)](https://codeclimate.com/github/vigetlabs/watch-dog)

This is small [Sinatra](http://www.sinatrarb.com/) app for managing a set
of [monit](http://mmonit.com/) checks on remote web sites.

It allows you specify the URL you want to monitor, text that should be on the page,
how many failure cycles are required for to report as the site being down, and an email
address to send the alert to.

There is a very basic web interface that allows to to create and edit which sites you're
monitoring and reports on the status of the sites you're monitoring.

## Requirements

* Ruby
* A web server (e.g. apache with [Passenger](http://www.modrails.com/))
* SQLite3
* [monit](http://mmonit.com/)

## Setup

1. Copy config/database.example.yml to config/database.yml and fill in the correct settings
2. Copy config/settings.example.yml to config/settings.yml and fill in the correct settings
3. Copy config/deploy.example.rb to config/deploy.rb and make the necessary changes
4. Add this line to your monit control file:

    `include /path/to/watch-dog/monitrc/**/*.monitrc`


Copyright (c) 2009 Viget Labs. See LICENSE for details.
