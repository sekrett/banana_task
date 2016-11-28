# Suppress 'Rendered template ...' messages in the log
# source: http://stackoverflow.com/a/16369363
if Rails.env.production?
  %w{render_template render_partial render_collection}.each do |event|
    ActiveSupport::Notifications.unsubscribe "#{event}.action_view"
  end
end
