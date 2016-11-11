class SubProject < Project

  belongs_to :project, foreign_key: 'project_id'
  has_many :properties, dependent: :destroy, foreign_key: 'sub_project_id'

  validates :project, uniqueness: { scope: :title }
  validates :project_id, check_city: true

  def self.default_scope
    where.not(project_id: nil)
  end

  def project_title
    project.title.titleize
  end
end
