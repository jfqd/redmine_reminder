# Redmine Reminder

Issue reminder plugin for redmine. Sends email notifications for open issues to the assigned user, project manager or a fallback email address.

## Features

* Send a reminder email to the assigned user of the open issue
* If no user is assigned to the issue the email address of the project manager is used
* If no project manager email address is available a fallback email address is used
* send a notification email to the project manager if a new issue was created
* send notifications by email and sms if an issue with a pre defined priority was created

## Getting the plugin

A copy of the plugin can be downloaded from GitHub: http://github.com/jfqd/redmine_reminder

## Installation

To install the plugin clone the repro from github and migrate the database:

```
cd <into your redmine root directory>
git clone git://github.com/jfqd/redmine_reminder.git vendor/plugins/redmine_reminder
rake redmine:plugins:migrate RAILS_ENV=production
```

To uninstall the plugin migrate the database back and remove the plugin:

```
cd <into your redmine root directory>
rake redmine:plugins:migrate NAME=redmine_reminder VERSION=0 RAILS_ENV=production
rm -rf vendor/plugin/redmine_reminder
```

Further information about plugin installation can be found at: http://www.redmine.org/wiki/redmine/Plugins.

## Usage Notification

* add the custom field 'notification-mail-addresses' to a project in the project configuration and add one or more email addresses separated by a comma
* add the custom field 'notification-mail-priority' to a project in the project configuration and add an id (!) of a trigger priority
* add the custom field 'notification-sms-phone-numbers' to a project in the project configuration and add one or more mobile phone numbers separated by a comma
* add the custom field 'notification-sms-priority' to a project in the project configuration and add an id (!) of a trigger priority

## Usage Reminder

To use the reminder functionality you need to 

* add the project manager email-address to the custom field 'pm-email' of each project
* add a cronjob. The following syntax is for ubuntu linux:

```
45 4 * * * redmine /usr/bin/rake -f /path/to/redmine/Rakefile redmine:reminder:send_notification project=project_identifier fallback_email=info@example.com 1 > /dev/null
```

## Compatibility

The latest version of this plugin is only compatible with Redmine 2.4.x.

* A version for Redmine 1.2.x. up to 1.4.7. is tagged with [v1.4](https://github.com/jfqd/redmine_reminder/tree/v1.4 "plugin version for Redmine 1.2.x up to 1.4.7") and available for [download on github](https://github.com/jfqd/redmine_reminder/archive/v1.4.zip "download plugin for Redmine 1.2.x up to 1.4.7").
* A version for Redmine 2.3.x is tagged with [v2.3](https://github.com/jfqd/redmine_reminder/tree/v2.3 "plugin version for Redmine 2.3.x") and available for [download on github](https://github.com/jfqd/redmine_reminder/archive/v2.3.zip "download plugin for Redmine 2.3.x").

## License

This plugin is licensed under the MIT license. See LICENSE-file for details.

## Copyright

Copyright (c) 2012-2013 Stefan Husch, qutic development. The development has been fully sponsored by netz98.de
