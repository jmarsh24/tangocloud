class Tandas::TagsController < ApplicationController
  include ActionView::RecordIdentifier
  include Turbo::ForceFrameResponse

  skip_after_action :verify_authorized, only: :user_tags

  before_action :set_tanda

  def user_tags
    @user_taggings = @tanda.taggings.where(user: current_user).includes(:tag)

    render partial: "tandas/tags", locals: {tanda: @tanda, user_taggings: @user_taggings}
  end

  def create
    @tag = Tag.find_or_create_by!(name: params[:name])
    authorize Tagging.new(taggable: @tanda, user: current_user), :create?

    tagging = @tanda.taggings.find_or_initialize_by(tag: @tag, user: current_user)
    tagging.save! unless tagging.persisted?

    user_taggings = @tanda.taggings.where(user: current_user).includes(:tag)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@tanda, :tags), partial: "tandas/tags", locals: {tanda: @tanda, user_taggings:}, method: :morph)
      end
    end
  end

  def destroy
    @tag = @tanda.tags.find(params[:id])
    tagging = @tanda.taggings.find_by(tag: @tag, user: current_user)
    authorize tagging, :destroy? if tagging

    tagging&.destroy

    user_taggings = @tanda.taggings.where(user: current_user).includes(:tag)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@tanda, :tags), partial: "tandas/tags", locals: {tanda: @tanda, user_taggings:}, method: :morph)
      end
    end
  end

  private

  def set_tanda
    @tanda = Tanda.find(params[:tanda_id])
  end
end
