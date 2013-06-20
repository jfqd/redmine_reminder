class CreateVariousCustomFields < ActiveRecord::Migration
  def self.up
    #
    # Contains the priority from which up the
    # notification mail should be delived.
    #
    c = CustomField.new(
      :name => 'notification-mail-priority',
      :editable => true,
      :visible => true,
      :min_length => 0,
      :max_length => 1,
      :regexp => '^[0-9]+$',
      :field_format => 'int')
    c.type = 'ProjectCustomField' # cannot be set by mass assignment!
    c.save
    
    #
    # Send the notification mail to the addresses
    # specified in this field.
    #
    c = CustomField.new(
      :name => 'notification-mail-addresses',
      :editable => true,
      :visible => true,
      :field_format => 'string')
    c.type = 'ProjectCustomField' # cannot be set by mass assignment!
    c.save
    
    #
    # Contains the priority from which up the
    # notification sms should be delived.
    #
    c = CustomField.new(
      :name => 'notification-sms-priority',
      :editable => true,
      :visible => true,
      :min_length => 0,
      :max_length => 1,
      :regexp => '^[0-9]+$',
      :field_format => 'int')
    c.type = 'ProjectCustomField' # cannot be set by mass assignment!
    c.save
    
    #
    # Send the notification sms to the phone numbers
    # specified in this field.
    #
    c = CustomField.new(
      :name => 'notification-sms-phone-numbers',
      :editable => true,
      :visible => true,
      :field_format => 'string')
    c.type = 'ProjectCustomField' # cannot be set by mass assignment!
    c.save
  end
  
  def self.down
    CustomField.find_by_name('notification-mail-priority').delete
    CustomField.find_by_name('notification-mail-addresses').delete
    CustomField.find_by_name('notification-sms-priority').delete
    CustomField.find_by_name('notification-sms-phone-numbers').delete
  end
end