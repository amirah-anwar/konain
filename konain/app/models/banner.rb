class Banner < ActiveRecord::Base

  DEFAULT_BANNER_URL = "innerBannerBgImg.png"
  DEFAULT_HOME_BANNER_URL = "homePageBannerSize.png"

  PAGES = ["Home Page", "Property Listings", "Edit Property", "New Property", "Property Details", "User Profile",
          "Edit User Profile", "Contact Us", "Projects Listings", "Project Details", "Agent Listings", "Lawyers Listings", "Architects Listings"]

  belongs_to :page

  has_attached_file :image,
                    styles: lambda{ |a|  if a.instance.home_page?
                                            { extra_large: "1286x970!", thumb: "150x150#" }
                                          else
                                            { large: "1286x175!", thumb: "150x150#" }
                                          end
                                          },
                     url: "/system/banners/:id/:style/:basename.:extension",
                     path: ":rails_root/public/system/banners/:id/:style/:basename.:extension"

  validates_attachment :image,
                        content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
                        size: { less_than: 10.megabytes }

  validates :name, presence: true, uniqueness: true

  before_validation { self.image.destroy if self.remove_image == '1' }

  scope :selected_banner, -> (name){ where(name: name) }

  attr_writer :remove_image

  def remove_image
    @remove_image || false
  end

  def self.fetch_url(name)
    banner = selected_banner(name).first
    if name == "Home Page"
      return DEFAULT_HOME_BANNER_URL if banner.blank?
      return DEFAULT_HOME_BANNER_URL unless banner.image.exists?
      banner.url(name)
    else
      return DEFAULT_BANNER_URL if banner.blank?
      return DEFAULT_BANNER_URL unless banner.image.exists?
      banner.url(name)
    end
  end

  def home_page?
    self.name == 'Home Page'
  end

  def url(name=nil)
    if name == "Home Page"
      self.try(:image).try(:url, :extra_large)
    else
      self.try(:image).try(:url, :large)
    end
  end

end
