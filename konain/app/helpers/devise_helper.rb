module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    _class = pre_login_alerts(params)

    html = <<-HTML
    <div style="position: relative;">
      <div class=#{_class}>
        <div class="alert alert-error alert-block">
          <button type="button" class="close" data-dismiss="alert">x</button>
          #{messages}
        </div>
      </div>
    </div>
    HTML

    html.html_safe
  end
end
