module ProjectsHelper

  def project_title(project)
    [project.title.titleize, project.location.titleize, project.city].join(", ")
  end

  def project_address(project)
    [project.location.titleize, project.city, project.country].join(", ")
  end

end
