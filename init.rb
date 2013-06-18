require 'redmine'
require 'my_mailer_patch'

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine reminder plugin'
  author 'Stefan Husch'
  description 'Redmine reminder plugin for netz98.de'
  version '0.0.2'
  requires_redmine :version_or_higher => '2.3.0'
end