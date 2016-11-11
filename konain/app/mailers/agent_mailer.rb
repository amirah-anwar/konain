class AgentMailer < ApplicationMailer

  def contact_email(name, email, contact, body, agent_email)
    @name = name
    @email = email
    @contact = contact
    @body = body

    mail(to: agent_email, from: @email, subject:"Konain Marketing: Client sent you a message")
  end
end
