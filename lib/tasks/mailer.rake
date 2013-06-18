namespace :redmine do
  namespace :reminder do
    
    desc "send email notifications to project manager or assigned users, optional parameters: [project=project_identifier] [fallback_email=info@example.com]"
    task :send_notification => :environment do
      # get open issues
      tables = [ :assigned_to, :status, :tracker, :project, :priority ]
      issues = unless ENV['project'].blank?
        query = Query.new(:project => Project.find_by_identifier(ENV['project']))
        Issue.open.find(:all, :include => tables, :conditions => query.statement)
      else
        Issue.open.find(:all, :include => tables)
      end
      fallback_email = ENV['fallback_email'].blank? ? nil : ENV['fallback_email']
      # send notification email to pm or assigned user
      puts "Processing #{issues.size} notifications..."
      issues.each { |issue| Mailer.reminder_notification(issue,fallback_email).deliver }
    end # task :send_notification
    
  end # namespace :email
end # namespace :redmine
