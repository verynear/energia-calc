# wegoaudit-ios

WegoWise Audit App iOS Project

### Setup

You must have Rubymotion in order to build this project.

1. Install XCode with the command line tools
2. Download and install
   [RubyMotion](http://www.rubymotion.com/files/RubyMotion%20Installer.zip)
2. Enter a license key
3. Use your Ruby version manager (rvm, rbenv, etc...) to install Ruby. Version
   1.9.2 is currently the officially supported version for RubyMotion, but we
   are using the version specified in `.ruby_version`.
4. bundle install
5. pod setup
6. rake pod:install

You will also need to setup and have the wegoaudit-server app running on
`localhost:9292`.

### Config

Copy config/development.yml.example to config/development.yml and modify as necessary.

### Running the application

Execute ```rake``` in your terminal.

### Running tests

To run all the tests:

```
rake spec
```

To run specific files:

```
rake spec files=<comma-separated-paths-to-files>
```

### Distributing New Builds

We use a third-party service called [HockeyApp](http://hockeyapp.net) to
distribute private builds of WegoAudit to beta testers. You have the option of
building either a "staging" or "production" version of the application,
depending on who you wish to distribute the build to.

We build two separate versions of the application with different identifiers
and version numbers to allow internal WegoWise testers to have both versions
installed at the same time.

Before deploying a build, you will need to create a HockeyApp account and
[register an upload API token](https://rink.hockeyapp.net/manage/auth_tokens)
for all apps. You should set this as an environment variable.

```shell
# Add the following to .zshrc or .bashrc with your real token.
export HOCKEYAPP_UPLOAD_TOKEN=00000000000000000000000000000000
```

You will also need to create and download a "distribution" certificate from the
[Apple Developer
Portal](https://developer.apple.com/account/ios/certificate/certificateList.action).
Add this certificate to your keychain by double-clicking it after it finishes
downloading. Add the name of the certificate to the `codesign_certificate` line
in Rakefile.

#### For staging

If you are building for staging, the short git SHA will be automatically added
to the version number so that you do not need to manually increment each build.
Run the rake task, and a new build will be pushed to HockeyApp.

```shell
rake deploy:staging
```

**Note:** "Staging" builds should only be distributed internally within
WegoWise due to login restrictions on our staging server.

#### For production

For production builds, you will need to open the `Rakefile` and manually bump
the short version number. Then run the production rake task.

```shell
rake deploy:production
```

You should also tag the commit with the new version number.

```shell
git tag v0.0.0
git push --tags
```
