require 'pagination/app/controllers/controller_ext'
require 'pagination/app/helpers/helper'
require 'pagination/app/models/engine'
require 'pagination/app/models/relation_methods'
require 'pagination/app/models/array_methods'

ActiveSupport.on_load(:action_view) do
  ::ActionView::Base.send(:include, Pagination::Helper)
end

module Pagination
end
