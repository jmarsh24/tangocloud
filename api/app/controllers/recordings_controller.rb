class RecordingsController < ApplicationController
  skip_after_action :verify_authorized
  skip_before_action :authenticate

  def show
    app_url = "tangocloudapp://player/#{params[:id]}"

    redirect_to app_url, allow_other_host: true
  end
end
