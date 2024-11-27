# frozen_string_literal: true

# Test controller
class TestController < ApplicationController
  before_action :authenticate_user!
  def test
    render json: { status: 'success', user: current_user }, status: :ok
  end
end
