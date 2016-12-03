class API::V1::PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
end
