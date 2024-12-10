class CompositionsController < ApplicationController
  def show
    authorize @composition = Composition.includes(
      :composers,
      :lyricists,
      :lyrics,
      recordings: [:orchestra, :genre, :singers]
    ).find(params[:id])
  end
end
