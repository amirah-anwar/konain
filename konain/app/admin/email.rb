ActiveAdmin.register Email do
  menu label: "Contacts"
  actions :all, except: [:edit, :new]

  scope :all
  scope "Admin Contacts", :admin_contact

  index title: "Contacts", download_links: false do
    selectable_column
    column "Agent" do |email|
      find_agent(email).name.titleize
    end
    column "Agent Email Address" do |email|
      find_agent(email).email
    end
    column "Sender Name" do |email|
      email.sender_name.titleize
    end
    column "Sender Email", :user_email
    column "Sender Contact", :contact
    column "Message" do |email|
      div class: "email_message" do
        truncate(email.body, omission: "... (continued)", length: 200)
      end
    end

    actions name: "Actions"
  end

  show title: "Email Details" do
    attributes_table do
      row "Agent" do |email|
        email.agent.name.titleize
      end
      row "Agent Email Address" do |email|
        email.agent.email
      end
      row "Sender Name" do |email|
        email.sender_name.titleize
      end
      row "Sender Email" do |email|
        email.user_email
      end
      row "Sender Contact" do |email|
        email.contact
      end
      row "Message" do |email|
        div class: "email_message" do
          email.body
        end
      end
    end
  end

end
