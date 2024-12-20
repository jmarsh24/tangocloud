module Api
  class RecordingsController < ApplicationController
    skip_after_action :verify_authorized
    skip_before_action :authenticate_user!

    def show
      @recording = Recording.find(params[:id])
      @deeplink_url = "tangocloudapp://recordings/#{params[:id]}"
    end
  end
end
