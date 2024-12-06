# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
end
