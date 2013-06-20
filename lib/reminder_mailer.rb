#
# With Rails 3 mail is send with the mail method. Sadly redmine
# uses this method-name too in their mailer. This is the reason
# why we need our own Mailer class.
#
class ReminderMailer < ActionMailer::Base
  #include Rails.application.routes.url_helpers
  
  # set the hostname for url_for helper
  def self.default_url_options
    { :host => Setting.host_name, :protocol => Setting.protocol }
  end
  
  def send_reminder(issue,fallback_email=nil,recipient=nil,language='de')
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
          :action => 'show',
          :id => issue
        )
      )
      # create mail object
      mail(
       :bcc     => recipients,
       :subject => subject,
       :body    => body,
       :date    => Time.zone.now
      )
    rescue => e
      puts "Failed to send reminder notification #{e.message}"
    end
  end
  
  # Send email
  def notification_mail(issue, recipients, subject, body)
    redmine_headers 'Project' => issue.project.identifier,
                    'Issue-Id' => issue.id
    message_id issue
    
    body = case body
      when :reminder_pm_body
        reminder_pm_body(issue)
      when :reminder_priority_body
        reminder_priority_body(issue)
      when :reminder_sms_body
        reminder_sms_body(issue)
    end
    # sending out the journal note to the support client
    mail(
      :from    => Setting.mail_from,
      :bcc     => recipients,
      :subject => subject,
      :body    => body,
      :date    => Time.zone.now
    )
  end
  
  private
  
  # Appends a Redmine header field (name is prepended with 'X-Redmine-')
  def redmine_headers(h)
    h.each { |k,v| headers["X-Redmine-#{k}"] = v.to_s }
  end
  
  def message_id(object)
    @message_id_object = object
  end
  
  def reminder_pm_body(issue)
    I18n.t(:reminder_pm_body,
      :project_name => issue.project.name,
      :issues_url => url_for(
        :controller => 'issues',
        :action => 'show',
        :id => issue
      )
    )
  end
  
  def reminder_priority_body(issue)
    I18n.t(:reminder_priority_body,
      :project_name => issue.project.name,
      :priority => (issue.priority.present? ? issue.priority.name : 'undefined'),
      :issues_url => url_for(
        :controller => 'issues',
        :action => 'show',
        :id => issue
      )
    )
  end
  
  def reminder_sms_body(issue)
    I18n.t(:reminder_sms_body,
      :project_name => issue.project.name,
      :priority => (issue.priority.present? ? issue.priority.name : 'undefined'),
      :issues_url => url_for(
        :controller => 'issues',
        :action => 'show',
        :id => issue
      )
    )
  end
  
end
