# Redmine Reminder

Issue reminder plugin for redmine. Sends email notifications for open issues to the assigned user, project manager or a fallback email address.

## Features

* Send a reminder email to the assigned user of the open issue
* If no user is assigned to the issue the email address of the project manager is used
* If no project manager email address is available a fallback email address is used

## Getting the plugin

A copy of the plugin can be downloaded from {GitHub}[http://github.com/jfqd/redmine_reminder]

## Installation

To install the plugin clone the repro from github and migrate the database:

```
cd <into your redmine root directory>
git clone git://github.com/jfqd/redmine_reminder.git vendor/plugin/redmine_reminder
rake db:migrate_plugins RAILS_ENV=production
```

To uninstall the plugin migrate the database back and remove the plugin:

```
cd <into your redmine root directory>
rake db:migrate:plugin NAME=redmine_reminder VERSION=0 RAILS_ENV=production
rm -rf vendor/plugin/redmine_reminder
```

Further information about plugin installation can be found at: http://www.redmine.org/wiki/redmine/Plugins.

## Usage

To use the helpdesk functionality you need to 

* add the project manager email-address to the custom field 'pm-email' of each project
* add a cronjob. The following syntax is for ubuntu linux:

```
45 4 * * * redmine /usr/bin/rake -f /path/to/redmine/Rakefile redmine:reminder:send_notification project=project_identifier fallback_email=info@example.com 1 > /dev/null
```

## Compatibility

This plugin was written for Redmine v1.2.x. Any other version might work.

## License

This plugin is licensed under the MIT license. See LICENSE-file for details.

## Copyright

Copyright (c) 2012 Stefan Husch, qutic development. The development has been fully sponsored by netz98.de


rake -f /Users/jerry/Desktop/netz98-redmine/Rakefile redmine:reminder:send_notification project=project_identifier fallback_email=info@example.com