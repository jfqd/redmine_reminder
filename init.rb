require 'redmine'
require 'mailer_patch'

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine reminder plugin'
  author 'Stefan Husch'
  description 'Redmine reminder plugin for netz98.de'
  version '0.0.1'
end