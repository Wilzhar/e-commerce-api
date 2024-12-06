# frozen_string_literal: true

module Auth
  # Sessions controller
  class SessionsController < DeviseTokenAuth::SessionsController
    before_action :authenticate_user!

    # Logout from all sessions
    def logout_all
      # Clear all the tokens (log out from all devices)

      puts "TOKENS: #{current_user.tokens}"
      current_user.tokens = {}

      # Save the updated user object
      if current_user.save
        render json: { message: 'Logged out from all devices' }, status: :ok
      else
        render json: { error: 'Failed to log out from all devices' },
               status: :unprocessable_entity
      end
    end
  end
end
