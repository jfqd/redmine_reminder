module RedmineHelpdesk
  module IssueObserverPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        alias_method_chain :after_create,  :reminder
      end
    end

    module InstanceMethods
      # Overrides the after_create method
      def after_create_with_reminder(issue)
        Mailer.issue_add(issue).deliver if Setting.notified_events.include?('issue_added')
        # now lets run our after_create hooks
        send_notification_mail issue
        send_priority_notification_mail issue
        send_priority_notification_sms issue
      end
      
      # check if a notification mail should be send to
      # the email addresse inside of the PM-Email field
      def send_notification_mail(issue)
        project = issue.project
        field = CustomField.find_by_name('pm-email')
        return if project.nil? || field.blank?
        recipient = project.custom_value_for(field).try(:value)
        if recipient.blank?
          Rails.logger.warn("[IssueObserver#send_notification_mail] empty 'pm-email' custom field. Cannot send notification mail")
          return
        end
        # send notification mail to pm
        subject = "[#{project.name} - #{issue.tracker.name} ##{issue.id}] PM NOTIFICATION : #{issue.subject}"
        ReminderMailer.notification_mail(issue, recipient, subject, :reminder_pm_body).deliver
      end
      
      # if the new issue has a pre defined priority
      # send a notification mail to the support stuff
      def send_priority_notification_mail(issue)
        project = issue.project
        field = CustomField.find_by_name('notification-mail-priority')
        return if project.nil? || field.blank?
        priority = project.custom_value_for(field).try(:value)
        return unless issue.priority_id >= priority.to_i
        # get recipients
        field = CustomField.find_by_name('notification-mail-addresses')
        recipients = project.custom_value_for(field).try(:value)
        if recipients.blank?
          Rails.logger.warn("[IssueObserver#send_priority_notification_mail] empty 'notification-mail-addresses' custom field. Cannot send notification mail")
          return
        end
        # send notification mail to support stuff
        recipients = recipients.split(",").collect(&:strip) # rescue nil
        if recipients.nil?
          Rails.logger.warn("[IssueObserver#send_priority_notification_mail] rescue 'notification-mail-addresses' to_a. Cannot send notification mail")
          return
        end
        subject = "[#{project.name} - #{issue.tracker.name} ##{issue.id}] PRIORITY NOTIFICATION : #{issue.subject}"
        ReminderMailer.notification_mail(issue, recipients, subject, :reminder_priority_body).deliver
      end
      
      # if the new issue has a pre defined priority
      # send a notification sms to the support stuff
      def send_priority_notification_sms(issue)
        project = issue.project
        field = CustomField.find_by_name('notification-sms-priority')
        return if project.nil? || field.blank?
        priority = project.custom_value_for(field).try(:value) || 10
        return unless issue.priority_id >= priority.to_i
        # get recipients
        field = CustomField.find_by_name('notification-sms-phone-numbers')
        phone_numbers = project.custom_value_for(field).try(:value)
        if phone_numbers.blank?
          Rails.logger.warn("[IssueObserver#send_priority_notification_sms] empty 'notification-sms-phone-numbers' custom field. Cannot send notification sms")
          return
        end
        # send notification sms to support stuff
        ReminderMailer.notification_mail(issue, phone_numbers, nil, :reminder_sms_body)
      end
      
    end # module InstanceMethods
  end # module JournalObserverPatch
end # module RedmineHelpdesk

# Add module to IssueObserver class
IssueObserver.send(:include, RedmineHelpdesk::IssueObserverPatch)
