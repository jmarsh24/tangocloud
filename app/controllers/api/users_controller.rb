module Api
  class UsersController < BaseController
    before_action :authorize_access_request!, only: [:show]

    # @route POST /api/users (api_users)
    def create
      user = User.new(user_params)

      if user.save
        user.send_confirmation_instructions if user.respond_to?(:send_confirmation_instructions)

        render json: {current_user: current_user.to_json, user: user.to_json}, status: :created
      else
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # @route GET /api/users/:id (api_user)
    def show
      user = User.find(params[:id])
      render json: {current_user: current_user.to_json, user: user.to_json}
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  end
end
