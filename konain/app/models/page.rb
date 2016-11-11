class Page < ActiveRecord::Base

  DEFAULT_LINKS = ['terms_and_conditions']

  has_one :banner, dependent: :destroy

  validates :name, presence: true
  validates :permalink, uniqueness: true

  before_validation :set_page_permalink
  before_validation :set_banner_name

  accepts_nested_attributes_for :banner, allow_destroy: true

  def self.render_permalink(name)
    record = self.find_by_name(name)
    record.present? ? ["/",record.permalink].join("") : ["/","pages"].join("")
  end

  private

  def set_page_permalink
    return if self.permalink.in?(DEFAULT_LINKS)
    name = self.name.downcase
    self.permalink = name.gsub(" ", "_")
  end

  def set_banner_name
    if self.banner.present?
      self.banner.name = self.name
    end
  end

end
