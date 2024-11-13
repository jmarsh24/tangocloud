class LibraryItemsController < ApplicationController
  def reorder
    library_item = @user_library.library_items.find(params[:id])

    authorize library_item
    
    library_item.update!(row_order_position: params[:position])
    head :ok
  end
end
