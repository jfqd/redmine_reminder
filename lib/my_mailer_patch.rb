module RedmineReminder
  module MyMailerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      
      def reminder_notification(issue,fallback_email=nil,recipient=nil,language='de')
        begin
          unless issue.assigned_to.nil?
            recipient = issue.assigned_to.mail
            language  = issue.assigned_to.language
          else
            c = CustomField.find_by_name('pm-email')
            recipient = issue.custom_value_for(c).try(:value)
            # puts "CustomField.value => #{recipient}"
          end
          recipient = fallback_email if recipient.blank? && !fallback_email.blank?
          puts "Send reminder notification for issue ##{issue.id} to #{recipient}."
          set_language_if_valid language
          recipients = recipient
          due_date = issue.due_date.nil? ? '-' : I18n.l(issue.due_date)
          subject = I18n.t(:reminder_subject,
            :project_name => issue.project.name,
            :issue_id => issue.id,
            :subject => issue.subject,
            :field_due_date => I18n.t(:field_due_date),
            :due_date => due_date
          )
          body = I18n.t(:reminder_body,
            :project_name => issue.project.name,
            :issue_id => issue.id,
            :subject => issue.subject,
            :field_due_date => I18n.t(:field_due_date),
            :due_date => due_date,
            :issues_url => url_for(
              :controller => 'issues',
              :action => 'index',
              :set_filter => 1,
              :assigned_to_id => issue.assigned_to_id,
              :sort => 'due_date:asc'
            )
          )
          # create mail object
          mail(
           :to      => recipients,
           :subject => subject,
           :body    => body,
           :date    => Time.zone.now
          )
        rescue Exception => e
          "Failed to send reminder notification #{e.message}"
        end
      end
      
    end # module InstanceMethods
  end # module MailerPatch
end # module RedmineHelpdesk

# Add module to Mailer class
Mailer.send(:include, RedmineReminder::MyMailerPatch)
