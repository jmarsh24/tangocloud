class PwasController < ApplicationController
  layout false
  skip_after_action :verify_policy_scoped, :verify_authorized

  def manifest
    respond_to do |format|
      format.json
    end
  end
end
