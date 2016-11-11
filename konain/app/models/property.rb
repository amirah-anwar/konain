class Property < ActiveRecord::Base

  include PropertyTypes
  include MathCalculations

  CITIES = ['Lahore', 'Karachi', 'Islamabad', 'Gwadar']
  UNITS = ['Square Feet', 'Square Yards', 'Square Meters', 'Marla', 'Kanal']
  CATEGORY = ['Sale', 'Rent']
  STATES = ["pending", "approved", "denied"]
  MINIMUM_RANGE = 0
  MAXIMUM_RANGE = 2147483646
  MAXIMUM_PRICE_RANGE = 1.4073749e+13
  FEATURED = 3
  RELATED_PROPERTIES = 4
  PAGINATION = 5
  HOME_FEATURED = 8
  REQUIRED_STATES = ["pending", "approved"]

  belongs_to :user
  belongs_to :agent, class_name: "User"
  belongs_to :project
  belongs_to :sub_project
  has_many :attachments, as: :imageable, dependent: :destroy
  has_many :favourites, as: :favourited, dependent: :destroy
  has_many :users, through: :favourites

  validates :category, :city, :title, :price, :land_area, :area_unit, :user_id,
            :property_type, presence: true

  validates :land_area, :bathroom_count, :bedroom_count, numericality: { greater_than_or_equal_to: MINIMUM_RANGE, less_than_or_equal_to: MAXIMUM_RANGE }
  validates :end_price, numericality: { greater_than_or_equal_to: MINIMUM_RANGE, less_than_or_equal_to: MAXIMUM_PRICE_RANGE }
  validates :price, numericality: { greater_than: MINIMUM_RANGE, less_than_or_equal_to: MAXIMUM_PRICE_RANGE }

  validates :property_type, inclusion: { in: Proc.new { |property| PROPERTY_TYPES[property.category].to_a },
            message: "%{value} is not valid for selected Category" }, if: Proc.new { |property| property.property_type.present? }

  validates :property_sub_type, presence: true, if: Proc.new { |property| PROPERTY_SUB_TYPES.keys.include?(property.property_type) }

  validates :property_sub_type, inclusion: { in: Proc.new { |property| PROPERTY_SUB_TYPES[property.property_type].to_a },
      message: "%{value} is not valid for selected Property Type" }, if: Proc.new { |property| property.property_sub_type.present? }

  validates :property_features, property_features_inclusion: true
  validates :state, presence: true
  validates_presence_of :project_id, message: "'s society cannot be blank"
  validates :project_id, check_city: true
  validates :sub_project_id, check_project: true
  validates :description, length: { maximum: 2000 }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  before_save :set_featured_at, if: :featured_or_home_listing_changed?
  before_save :set_property_lat_lng

  scope :ordered, -> { order(id: :desc) }

  scope :featured_properties, -> { active_properties.where(featured: true) }

  scope :active_properties, -> { where(closed_at: nil, state: 'Approved') }

  scope :ordered_featured_properties, -> { featured_properties.ordered_by_featured }

  scope :home_listing_featured_properties, -> { active_properties.where(home_listing: true).ordered_by_featured }

  scope :ordered_by_featured, -> { order(featured_at: :desc) }

  scope :assigned_properties, -> (user){ where(agent_id: user.id) }

  scope :properties_added_in_day, -> { where(created_at: Time.now - 1.day..Time.now) }

  scope :properties_added_in_week, -> { where(created_at: Time.now - 1.week..Time.now) }

  scope :properties_added_in_month, -> { where(created_at: Time.now - 1.month..Time.now) }

  scope :deals_closed, -> (user){ assigned_properties(user).where.not(closed_at: nil) }

  def location
    return unless project_id.present?
    project = Project.find_by_id(project_id)
    return unless project.present?
    project.location
  end

  def full_address
    property_location = location.titleize if location.present?
    property_city = self.city.titleize if self.city.present?
    [property_location, property_city, "Pakistan"].join(", ")
  end

  def self.perform_search(params)
    params = {} if params.blank?

    search_params = default_search_params
    search_params[:page] = params[:page]

    per_page = params[:per_page].present? ? params[:per_page] : PAGINATION
    search_params[:per_page] = per_page

    order = params[:order].present? ? params[:order] : "created_at DESC"
    search_params[:order] = order

    search_params[:with][:closed_at] =  Zlib::crc32(params[:closed_at])

    search_params[:with][:favourited_type] = Zlib::crc32(params[:favourited_type]) if params[:favourited_type].present?
    search_params[:with][:favourited_user_id] = params[:favourited_user_id] if params[:favourited_user_id].present?

    search_params[:with][:state] = state_search(params)
    search_params[:with][:project_id] = params[:project_id].to_i if params[:project_id].present?
    search_params[:with][:category] = Zlib::crc32(params[:category]) if params[:category].present?
    search_params[:with][:city] = Zlib::crc32(params[:city]) if params[:city].present?
    search_params[:with][:bedroom_count] = params[:bedroom_count].to_i if params[:bedroom_count].present?
    search_params[:with][:bathroom_count] = params[:bathroom_count].to_i if params[:bathroom_count].present?
    search_params[:with][:price] = price_range(params[:min_price], params[:max_price]) if params[:min_price].present? || params[:max_price].present?
    search_params[:with][:user_id] = params[:user_id].to_i if params[:user_id].present?
    search_params[:with][:agent_id] = params[:agent_id].to_i if params[:agent_id].present?
    search_params[:with][:land_area] = params[:land_area].to_f if params[:land_area].present?
    search_params[:with][:area_unit] = Zlib::crc32(params[:area_unit]) if params[:area_unit].present?
    search_params[:with][:property_type] = Zlib::crc32(params[:property_type]) if params[:property_type].present?
    search_params[:with][:home_listing] = params[:home_listing] if params[:home_listing].present?
    search_params[:with][:sub_project_id] = params[:sub_project_id].to_i if params[:sub_project_id].present?
    search_params[:with][:id] = params[:property_id].to_i if params[:property_id].present?

    self.search search_params
  end

  def self.default_search_params
    { conditions: {},
      with: {},
      without: {},
      sql: { include: :attachments },
    }
  end

  def self.state_search(params)
    params[:state].present? ? params[:state].collect{ |state| Zlib::crc32(state) } : Zlib::crc32("approved")
  end

  def self.price_range(min_price, max_price)
    if min_price.present? && max_price.blank?
      min_price.to_i..MAXIMUM_PRICE_RANGE.to_i
    elsif min_price.blank? && max_price.present?
      MINIMUM_RANGE..max_price.to_i
    elsif min_price.present? && max_price.present?
      min_price.to_i..max_price.to_i
    end
  end

  def self.property_fields_array(properties)
    properties.collect{ |property| [property.get_project.latitude, property.get_project.longitude, property.id] }
  end

  def get_project
    self.sub_project.present? ? self.sub_project : self.project
  end

  def property_features=(value)
    value.reject!(&:blank?)
    self.send("write_attribute", "property_features", value.join(", "))
  end

  def property_features
    self.read_attribute(:property_features).to_s.split(", ")
  end

  def related_properties

    lat = self.project.lat_to_rad
    lng = self.project.lng_to_rad

    search_params = self.class.default_related_search_params

    search_params[:with][:area_unit] = Zlib::crc32(self.area_unit)
    search_params[:with][:property_type] = Zlib::crc32(self.property_type)
    search_params[:geo] = [lat,lng]
    search_params[:with][:geodist] = (0.0..10_000.0)

    search_params[:with][:city] = Zlib::crc32(self.city)
    search_params[:with][:state] = Zlib::crc32("approved")
    search_params[:with][:land_area] = self.land_area.to_i
    search_params[:without][:id] = self.id

    self.class.search search_params
  end

  def self.default_related_search_params
    {
      with: { closed_at: 0 },
      without: {},
      sql: { include: :attachments },
      order: "geodist ASC, @weight DESC",
    }
  end

  def assigned_agent
    return if self.agent_id.blank?
    self.agent.name.titleize
  end

  def self.export_csv(properties)
    csv = CSV.generate( encoding: 'Windows-1251' ) do |csv|
      csv << ["Total Properties Uploaded"]
      csv << ["In a Day", "In a Week", "In a Month"]
      csv << [properties_added_in_day.length, properties_added_in_week.length, properties_added_in_month.length]
      csv << ["Properties"]
      csv << ["Title", "Category", "Property SubType", "Property Type", "Price PKR.", "Location", "City", "Country"]
      properties.each do |property|
        csv << [ property.title, property.category, property.property_sub_type, property.property_type, property.price, property.location, property.city, property.project.country ]
      end
    end
  end

  def closed_at_time
    self.closed_at.present? ? self.closed_at.localtime.strftime("%B %d, %Y") : "Active"
  end

  def approved?
    self.state == "approved"
  end

  def pending?
    self.state == "pending"
  end

  def closed?
    self.closed_at.present?
  end

  def user_authorized?(user)
    user == self.user || user.is_admin_or_agent?
  end

  def cover_image
    attachments = self.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :index) || 'no_image_index.png'
  end

  def featured_image
    attachments = self.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :featured) || 'no_image_featured.png'
  end

  def related_image
    attachments = self.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :related) || 'no_image_related.png'
  end

  def home_featured_images
    attachments = self.attachments
    picture = attachments.first
    picture.try(:image).try(:url, :related) || 'no_image_home_featured.png'
  end

  def self.get_favourites(params)
    params[:favourited_user_id] = params[:id]
    self.perform_search(params)
  end

  def full_title
    [id, [title, location, city].join(', ')].join('. ')
  end

  def title_slug
    [id, title].join('. ')
  end

  private

  def set_featured_at
    self.featured_at = Time.now
  end

  def set_property_lat_lng
    self.latitude  = self.project.latitude
    self.longitude = self.project.longitude
  end

  def self.price_units
    {
      l: 'Lac(s)',
      a: 'Arab(s)',
      c: 'Crore(s)',
      k: 'Kharab(s)',
      h: 'Hundred(s)',
      t: 'Thousand(s)',
    }
  end

  private

  def featured_or_home_listing_changed?
    featured_changed? || home_listing_changed?
  end
end
