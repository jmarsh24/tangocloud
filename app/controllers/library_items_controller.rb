class LibraryItemsController < ApplicationController
  def index
    authorize @user_library, :show?

    library_items = @user_library.library_items

    library_items = case params[:type]
    when "playlists"
      library_items.where(item_type: "Playlist")
    when "tandas"
      library_items.where(item_type: "Tanda")
    else
      library_items
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update("library-items",
            partial: "library_items/index",
            locals: {library_items:,
                     active_filter: params[:type]},
            method: :morph)
      end
    end
  end

  def destroy
    library_item = @user_library.library_items.find(params[:id])

    authorize library_item

    library_item.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.remove("library_item_#{library_item.id}")
      end
    end
  end

  def reorder
    library_item = @user_library.library_items.find(params[:id])

    authorize library_item

    library_item.update!(row_order_position: params[:position])
    head :ok
  end
end
