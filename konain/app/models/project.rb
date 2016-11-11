class Project < ActiveRecord::Base

  include MathCalculations

  PAGINATION = 10
  CITIES = ['Lahore', 'Karachi', 'Islamabad', 'Gwadar']
  COUNTRIES = ['Pakistan']
  DEFAULT_PROJECTS_TITLE = ['Other - Lahore', 'Other - Islamabad', 'Other - Karachi']

  has_many :properties, dependent: :destroy
  has_many :attachments, as: :imageable, dependent: :destroy
  has_many :sub_projects, dependent: :destroy

  validates :title, :location, :city, :country, presence: true
  validates :title, length: { maximum: 30 }
  validates :description, length: { maximum: 2000 }
  validates :location, length: { maximum: 60 }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  geocoded_by :full_address
  after_validation :geocode

  scope :ordered, -> { order(id: :desc) }
  scope :projects_by_city, -> (city){ where(city: city) }

  after_save :adjust_properties_city
  after_save :adjust_sub_projects_city

  def self.default_scope
    where(project_id: nil)
  end

  def full_address
    [location, city, country].join(", ")
  end

  def self.project_fields_array(projects)
    projects.collect{ |project| [project.latitude, project.longitude, project.id] }
  end

  def self.perform_search(params)
    search_params = default_search_params

    search_params[:page] = params[:page]
    search_params[:per_page] = PAGINATION
    search_params[:with][:city] = Zlib::crc32(params[:city]) if params[:city].present?
    search_params[:without][:title_filter] = DEFAULT_PROJECTS_TITLE.collect{ |title| Zlib::crc32(title) } if params[:title].blank?
    search_params[:conditions][:title] = params[:title] if params[:title].present?

    self.search search_params
  end

  def self.default_search_params
    {
      conditions: {},
      with: { project_id: 0 },
      without: {},
      sql: { include: :attachments },
      order: "id DESC",
    }
  end

  def lat_to_rad
    Project.to_radians(self.latitude)
  end

  def lng_to_rad
    Project.to_radians(self.longitude)
  end

  def cover_image
    attachments = self.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :index) || 'no_image_index.png'
  end

  private

  def adjust_properties_city
    properties.each do |property|
      property.city = self.city
      property.latitude = self.latitude
      property.longitude = self.longitude
      property.save
    end
  end

  def adjust_sub_projects_city
    sub_projects.update_all(city: self.city)
  end

end
