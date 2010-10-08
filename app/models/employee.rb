class Employee < ActiveRecord::Base

  named_scope :roots, :conditions => ["reports_to = ?", 0]
  has_many :employees, :class_name => 'Employee', :foreign_key => 'reports_to'
  belongs_to :department

  def to_s
    "#{first} #{last}" 
  end

end
