class OrgChart
  require "rexml/document"

  def initialize(params={})
    @params = params 
  end
  
  def all_departments?
    @params[:department_ids].blank? || @params[:department_ids].any? {|e| e.blank?}
  end

  def roots
    all_departments? ? Employee.roots : departments.map {|d| d.root}
  end

  def departments
    all_departments? ? Department.all :  Department.find(@params[:department_ids])    
  end

  def draw
    roots.map {|root| Node.new(root).draw}.flatten.join("")
  end

  def svg 
    @svg ||= begin
      gv=IO.popen("dot -q -Tsvg","w+")
      gv.puts self.dot_digraph
      gv.close_write
      gv.read
    end
  end 

  def dot_digraph
    ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_digraph.html.erb")).result(binding)
  end

  def parsed_svg
    @parsed_svg ||= REXML::Document.new(svg)
  end
  
  def width
    parsed_svg.root.attributes["width"].gsub(/pt$/,'').to_i
  end
  
  def height
    parsed_svg.root.attributes["height"].gsub(/pt$/,'').to_i
  end

  class Node
    def initialize(employee)
      @employee = employee
    end

    def draw
      [draw_employee_box] + draw_children_with_children + draw_children_with_no_children
    end

    def draw_employee_box
      ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_employee_box.html.erb")).result(binding)
    end

    def draw_children_with_children
      children_with_children.map do |child_with_children|
        [Node.new(child_with_children).draw, 
          draw_employee_box, draw_employee_to_child_connection(child_with_children)] 
      end
    end

    def draw_children_with_no_children
      children_with_no_children.in_groups_of(10, false).map do |group|
        [draw_group_box(group), draw_employee_to_group_connection(group)]
      end
    end

    def draw_employee_to_child_connection(child_with_children)
      ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_employee_to_child_connection.html.erb")).result(binding)
    end

    def draw_group_box(group)
      ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_group_box.html.erb")).result(binding)
    end

    def draw_employee_to_group_connection(group)
      ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_employee_to_group_connection.html.erb")).result(binding)
    end

    def children_with_children
      @employee.employees.select {|e| !e.employees.include?(@employee) and (e.employees.size > 0)}
    end

    def children_with_no_children
      @employee.employees.select {|e| e.employees.size == 0} 
    end

    def label_for(employee)
      ERB.new(File.read(RAILS_ROOT+"/app/views/org_charts/_dot_employee_label.html.erb")).result(binding)
    end

  end



end
