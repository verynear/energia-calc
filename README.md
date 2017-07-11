# retrocalc

workflow that includes the following steps:

- perform an audit on a building (or set of buildings)
- decide on a set of recommended actions (for example, boiler replacement),
based on how each action affects the cost and savings of the recommendations
as a whole
- generate a report of the recommended actions

Retrocalc will also interact with the kilomeasure gem (see
vendor/gems/kilomeasure), which contains the calculations for each measure.

## Vocabulary

- **Audit:** A set of data gathered for a particular building (or set of
  buildings).  There are several types of audits, listed in
  `retrocalc/seeds.rb`.
- **Audit Report:** Users begin interacting with Retrocalc by creating an audit
  report based on a particular audit.  An audit report contains a set of
  measures, and will have an overall cost and savings.
- **Measure:** A specific recommendation; these are also listed in
  `retrocalc/seeds.rb`. Each measure will have its own cost and savings, and
  will require certain inputs in order to perform the calculations.


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


## Running the development server

Once your database has been created, you can start the server with `rails s`.

The server will start up using **port 9292** and your **private IP** address by
default so that you can connect to it from an external device. If you do not
already have it, you can get the address and port from the log output when the
server starts.

-------------------------------------------------------------------------------------
Some Devise setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

