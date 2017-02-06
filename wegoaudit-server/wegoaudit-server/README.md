# wegoaudit

The rails backend for wegoaudit-ios.

## Setup

In order to run a development environment, you're going to need to install a
few dependencies first. Most of these can be installed using
[Homebrew](http://brew.sh/).

* ruby
* postgresql
* redis
* imagemagick

Copy and customize the config/database.yml.example file. Create and seed the
database:

```
rake db:create db:migrate db:seed
```

Create an API token for a non-admin user in your WegoWise development
environment. Add the API credentials to your `.env.development` file.

```shell
export WEGOWISE_PROVIDER_KEY="YOUR_KEY"
export WEGOWISE_PROVIDER_SECRET="YOUR_SECRET"
```

## Running the development server

Once your database has been created, you can start the server with `rails s`.

The server will start up using **port 9292** and your **private IP** address by
default so that you can connect to it from an external device. If you do not
already have it, you can get the address and port from the log output when the
server starts.


