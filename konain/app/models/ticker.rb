class Ticker < ActiveRecord::Base

  validates :content, :title, presence: true
  validates :content, length: { maximum: 255 }
  validates :title, length: { maximum: 20 }

end
