class User < ActiveRecord::Base

  paginates_per 10
  COUNTRIES = ["Pakistan"]
  CITIES = ['Lahore', 'Karachi', 'Islamabad']
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ROLES = ['admin', 'agent', 'lawyer', 'architect']

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_one :attachment, as: :imageable, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_properties, through: :favourites, source: :favourited, source_type: 'Property'
  has_many :emails, class_name: 'Email', foreign_key: :agent_id, dependent: :destroy
  has_many :agent_properties, class_name: 'Property', foreign_key: :agent_id, dependent: :destroy

  validates :name, presence: true, length: { in: 3..50 }

  validates :email, uniqueness:true, format: { with: EMAIL_REGEX,
              message: "format should be: user@example.com" }

  validates :home_phone_code, presence: true, format: { with: /\A(0\d{2,3})\z/,
              message: "can be 3 or 4 digits" }

  validates :home_phone_number, presence: true, format: { with: /\A(\d{8})\z/,
              message: "should have 8 digits" }

  validates :mobile_phone_code, presence: true, format: { with: /\A(03\d{2})\z/,
              message: "format should be: 03xx" }

  validates :mobile_phone_number, presence: true, format: { with: /\A(\d{7})\z/,
              message: "should have 7 digits" }

  validates :terms_and_conditions, acceptance: true
  validates :address, length: { maximum: 200 }, allow_blank: true

  validates :fax_code, allow_blank: true, format: { with: /\A(0\d{2,3})\z/,
              message: "can be 3 or 4 digits starting with digit 0" }

  validates :fax_number, allow_blank: true, format: { with: /\A(\d{7})\z/,
              message: "should have 7 digits" }

  validates :zip_code, allow_blank: true, numericality: true, length: { maximum: 50},
              format: { with: /\A(\d{4,9})\z/,
                       message: "can be minimum 4 and maximum 9 digits." }

  validates :agent_description, allow_blank: true, length: { maximum: 255 }

  accepts_nested_attributes_for :attachment, allow_destroy: true

  scope :agents, -> { where(role: 'agent') }
  scope :ordered_agents, -> { agents.order(id: :desc) }

  scope :non_agents, -> { where.not(role: 'agent') }
  scope :ordered_non_agents, -> { non_agents.order(id: :desc) }

  scope :subscribers, -> { where(subscriber: true) }
  scope :ordered_subscribers, -> { subscribers.order(id: :desc) }
  scope :subscribers_emails, -> { ordered_subscribers.pluck(:email) }

  scope :admins, -> { where(role: 'admin') }

  scope :lawyers, -> { where(role: 'lawyer') }
  scope :ordered_lawyers, -> { lawyers.order(id: :desc) }

  scope :architects, -> { where(role: 'architect') }
  scope :ordered_architects, -> { architects.order(id: :desc) }

  before_destroy :check_admin?

  def home_number
    [self.home_phone_code, self.home_phone_number].join("-")
  end

  def mobile_number
    [self.mobile_phone_code, self.mobile_phone_number].join("-")
  end

  def fax
    [self.fax_code, self.fax_number].join("-")
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = where(email: auth.info.email).first_or_create
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.name = data["name"] if user.name.blank?
      end
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ['Subscribers']
      csv << ['emails']
      pluck(:email).each do |user|
        csv << [user]
      end
    end
  end

  def is_admin_or_agent?
    return true if self.admin?
    return true if self.agent?
    return false
  end

  def self.export_csv(properties, closed_properties, user)
    csv = CSV.generate( encoding: 'Windows-1251' ) do |csv|
      csv << ["Total Deals Closed"]
      csv << [closed_properties.length]
      csv << ["Sold/Rented Properties by Agent"]
      csv << ["Title", "Category", "Property SubType", "Property Type", "Sold/Rented at Price PKR.", "Location", "City", "Country"]
      closed_properties.each do |property|
        csv << [ property.title, property.category, property.property_sub_type, property.property_type, property.end_price, property.location, property.city, property.project.country ]
      end
      csv << ["Assigned Properties"]
      csv << ["Title", "Category", "Property SubType", "Property Type", "Price PKR.", "Location", "City", "Country"]
      properties.each do |property|
        csv << [ property.title, property.category, property.property_sub_type, property.property_type, property.price, property.location, property.city, property.project.country ]
      end
    end
  end

  def first_name
    name = self.name.split(" ")
    name[0]
  end

  def admin?
    role == 'admin'
  end

  def agent?
    role == 'agent'
  end

  def lawyer?
    role == 'lawyer'
  end


  private

  def check_admin?
    return false if self.admin?
  end

end
