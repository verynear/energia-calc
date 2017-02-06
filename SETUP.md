# WegoAudit

## iPad application

### Development

To setup a development environment, you will need to install the
[RubyMotion](http://www.rubymotion.com/) framework and purchase a license.

The most recent version of WegoAudit was built using Ruby 2.2, which can be
installed using [rbenv](https://github.com/rbenv/rbenv), but there's a good
chance that the version of Ruby installed on OS X by default will also work.

With those installed, you should be able to install all of the other
dependencies using:

```
gem install bundler
bundle install
pod setup
rake pod:install
```

### Configuration

You should customize the files in `config/` to match your development and
production environments. In these files, you should specify the location of
your WegoAudit and WegoWise servers.

### Certificates

Building WegoAudit for development and distribution requires generating
certificates at the [Apple Developer Portal](http://developer.apple.com/).
The current version of WegoAudit uses certificates registered to WegoWise's
organization account that will expire on December 8, 2016.

### Distribution

Users of WegoAudit must have their device UUIDs added to the provisioning
profile in the Apple Developer Portal. This can be done for each version of the
application that you distribute.

The build tasks are currently configured to look for two profiles in the
`profiles/` directory. These are:

* `profiles/WegoAudit_Beta_Profile.mobileprovision`
* `profiles/WegoAudit_Development_Profile.mobileprovision`

Distribution of the beta version has been done through a free account at
[Hockeyapp](htttps://hockeyapp.net).

## Server

### Dependencies

We have the following dependencies installed on an ubuntu 14.04 server:

* libpq-dev (for PostgreSQL client)
* nodejs (for a JavaScript runtime)
* imagemagick (for image resizing)

The following external services are also used:

* PostgreSQL 9.3 server
* Amazon S3 (for image hosting)
* Redis (for background job queue)

### Environment variables

You will need to set the following environment variables for a production
server:

- `DOORSTOP_SHARED_SECRET` -- should be the same as the value in Retrocalc
- `RAILS_ENV`: should be 'production' for a production server
- `REDIS_URL`: can be obtained by a Redis hosting provider, we used redisgreen.net
- `SECRET_KEY_BASE`: used for cookie encryption by Rails. Can be generated using `rake secret`.
- `SIDEKIQ_WEB_PASSWORD`: basic HTTP auth for the Sidekiq UI
- `SIDEKIQ_WEB_USER`: basic HTTP auth for the Sidekiq UI
- `WEGOWISE_PROVIDER_KEY`: can be obtained in WegoWise
- `WEGOWISE_PROVIDER_SECRET`: can be obtained in WegoWise
