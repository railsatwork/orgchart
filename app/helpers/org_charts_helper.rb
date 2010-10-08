module OrgChartsHelper

  def departments_select
   options_for_select([['All Departments', '']] + Department.active.map {|d| [d.name, d.id]})   
  end

end
