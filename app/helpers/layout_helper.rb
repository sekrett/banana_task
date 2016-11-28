module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def jquery_include_tag
    if Rails.env.production?
      javascript_include_tag 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js'
    else
      javascript_include_tag 'jquery'
    end
  end

  def flash_messages
    flash_messages = []
    flash.each do |type, message|
      type = type.to_sym
      type = :success if type == :notice
      type = :danger if type == :alert
      type = :danger if type == :error
      next unless [:success, :info, :warning, :danger].include?(type)

      close_button = content_tag(:button, type: 'button', class: 'close', 'data-dismiss' => 'alert', 'aria-label' => 'Close') do
        content_tag(:span, raw('&times;'), 'aria-hidden' => 'true')
      end

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, class: "flash alert alert-#{type} alert-dismissible", role: 'alert')
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def active_class(controller)
    controller_name == controller.to_s ? 'active' : nil
  end

  def table_class
    'table table-hover'
  end

  def btn_group(button_text = nil, &block)
    content_tag(:div, class: 'btn-group') do
      button_tag(type: 'button', class: 'btn btn-default dropdown-toggle', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false') do
        if button_text.present?
          (button_text + ' <span class="caret"></span>').html_safe
        else
          '<span class="fa fa-bars">'.html_safe
        end
      end + content_tag(:ul, class: 'dropdown-menu', &block)
    end
  end
end
