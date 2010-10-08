class Department < ActiveRecord::Base
  
  has_many :employees

  named_scope :active, :conditions => ["id > ?",0], :order => 'name'

  validates_presence_of :name
  
  belongs_to :manager, :class_name => "Employee", :foreign_key => :manager_id

  COLORS = %w(#C6B299 #E6D5C1 #FFF4E3 #C4BFE0 #A6C6FF #E8EEFF #F8F087 #B7E3C0 #B8D0DD #DBBAE5 #F39DD4)

  COLOR_ASSIGNMENTS = {}
  
  def root
    manager
  end
  
  def color
    COLOR_ASSIGNMENTS[self.id] ||= COLORS.pop   
  end

end


