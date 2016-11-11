class Email < ActiveRecord::Base

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  DEFAULT_EMAIL = "konain@default.com"
  MAXIMUM_DIGITS = 15
  COMPANY_ADDRESS = '164-Y Phase-3 Basement Commercial Zone DHA، Lahore.'
  COMPANY_COUNTRY = "Pakistan"
  COMPANY_LATITUDE = 31.4719753
  COMPANY_LONGITUDE = 74.3779518
  COMPANY_NAME = 'Konain Marketing'

  belongs_to :agent, class_name: "User"
  before_create :set_email
  after_create :trigger_email

  validates :sender_name, :contact, :body, presence: true
  validates :contact, numericality: true, length: { maximum: MAXIMUM_DIGITS }
  validates :user_email, allow_blank: true, format: { with: EMAIL_REGEX,
                              message: "format should be: user@example.com" }

  scope :admin_contact, -> { where("agent_id in (?)", User.admins.pluck(:id)) }

  def self.send_to_array(admins, params)
    emails = []
    admins.each do |admin|
      email = admin.emails.new(params)
      email.agent_id = admin.id
      emails << email
    end
    emails.select { |email| email unless email.save }
  end

  protected

  def set_email
    self.user_email = self.user_email.present? ? self.user_email : DEFAULT_EMAIL
  end

  def trigger_email
    AgentMailer.contact_email(self.sender_name,
                              self.user_email,
                              self.contact,
                              self.body,
                              self.agent.email).deliver_now
  end
end
