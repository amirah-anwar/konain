class Setting < ActiveRecord::Base

  DEFAULT_Settings = ["Ticker"]

  validates :title, presence: true, length: { maximum: 20 }

  scope :selected_setting, -> (title){ where(apply: true, title: title) }

end
