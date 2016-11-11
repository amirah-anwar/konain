class EmailsController < ApplicationController
  before_action :set_agent, only: [:send_mail]
  before_action :validate_email_field, only: [:send_contact_mail]
  before_action :set_admins, only: [:send_contact_mail]

  load_and_authorize_resource

  def send_mail
    @email = @agent.emails.new(email_params)
    if @email.save
      flash[:success] = "Thank you for contacting us. Our agent will get in touch with you soon via provided phone number."
      redirect_to referrer_path
    else
      flash[:error] = "Please provide all correct information in the contact form."
      redirect_to referrer_path
    end
  end

  def contact
    @email = Email.new
    gon.property_location = { "lat" => Email::COMPANY_LATITUDE, "lng" => Email::COMPANY_LONGITUDE }
    gon.address = Email::COMPANY_ADDRESS
    gon.country = Email::COMPANY_COUNTRY
    gon.company_name = Email::COMPANY_NAME
  end

  def send_contact_mail
    errors = Email.send_to_array(@admins, email_params)
    if errors.blank?
      flash[:success] = "Thank you for contacting us. We will get in touch with you soon via provided phone number."
      redirect_to contact_us_path
    else
      flash[:error] = "Please provide all correct information in the contact form."
      redirect_to contact_us_path
    end
  end

  private

  def email_params
    params.require(:email).permit(:sender_name, :user_email, :contact, :body, :agent_id)
  end

  def set_agent
    @agent = User.find_by_id params[:agent_id]
    if @agent.blank?
      return redirect_to :root, flash: { error: "Agent does not exist" }
    end
  end

  def set_admins
    @admins = User.admins
    return redirect_to :root, flash: { error: "Admin does not exist" } if @admins.blank?
  end

  def validate_email_field
    return redirect_to contact_us_path, flash: { error: "Please provide email address in the contact form." } if email_params[:user_email].blank?
  end

end
