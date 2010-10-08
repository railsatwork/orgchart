require 'csv'

namespace :app do
  #http://www.fakenamegenerator.com/
  task :seed_data => :environment do
    CSV.foreach("#{RAILS_ROOT}/lib/tasks/employees.csv", :headers => true) do |row|
      department = Department.find_or_create_by_name(row['department'])
      employee = Employee.find_or_create_by_external_id(row['external_id'])
      if(row['department_manager'] =~ /yes/i)
        department.update_attributes(:manager_id => employee.id)
      end

      if row['reports_to'].blank?
        reports_to = 0
      else
        reports_to = Employee.find_or_create_by_external_id(row['reports_to']).id
      end
      employee.update_attributes(:first => row['first'], :last => row['last'], 
        :reports_to => reports_to, :department_id => department.id, :title => row['title'])
    end
  end

end

