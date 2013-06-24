require 'redmine'
require 'issue_observer_patch'
require 'reminder_mailer'
require 'reminder_sms'

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine reminder plugin'
  author 'Stefan Husch'
  description 'Redmine reminder plugin for netz98.de'
  version '0.0.2'
  requires_redmine :version_or_higher => '2.3.0'
  
  settings :default => {
    'sms_gateway_url' => 'https://smsserver.mindmatics.com/messagegateway/',
    'sms_gateway_uid' => 'my user id',
    'sms_gateway_pwd' => 'my user pwd',
    'sms_gateway_sender_phone_number' => '0049170987654321'
  }, :partial => 'settings/sms_gateway'
  
end