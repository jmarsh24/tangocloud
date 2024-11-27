class TandaRecordingsController < ApplicationController
  def create
    @tanda = if params[:tanda_id].present?
      Tanda.find(params[:tanda_id])
    else
      Tanda.create!(user: current_user)
    end

    recording = Recording.find(params[:recording_id])
    authorize tanda_recording = @tanda.tanda_recordings.create!(recording:)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("tanda-recordings", partial: "tanda_recordings/tanda_recording", locals: {tanda_recording:})
        ]
      end
    end
  end
end
