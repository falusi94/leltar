class ImportController < ApplicationController

  def upload_csv
    return unauthorized_page unless current_user.admin
    if params[:csv_file]
      @bad_items = ImportCsv.call(params[:csv_file].read.force_encoding('UTF-8'))
      if @bad_items.size > 0
        render :csv_errors
      else
        redirect_to '/items'
      end
    else
      render inline: 'Unprocessable entity', status: :unprocessable_entity
    end
  end

end
