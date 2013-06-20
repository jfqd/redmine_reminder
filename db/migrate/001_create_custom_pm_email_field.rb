class CreateCustomPmEmailField < ActiveRecord::Migration
  def self.up
    c = CustomField.new(
      :name => 'pm-email',
      :editable => true,
      :visible => true,
      :field_format => 'string')
    c.type = 'ProjectCustomField' # cannot be set by mass assignment!
    c.save
  end

  def self.down
    CustomField.find_by_name('pm-email').delete
  end
end