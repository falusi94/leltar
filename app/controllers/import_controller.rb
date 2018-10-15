class ImportController < ApplicationController
  before_action :require_admin

  def new; end

  def create
    id = params[:sheet_id]
    redirect_to edit_import_path id
  end

  def edit
    import_helper = ImportFromSheets.new(params[:id])
    @sheets = import_helper.sheets
    @groups = Group.all
  end

  def update
    import_helper = ImportFromSheets.new(params[:id])
    result = import_helper.import(params)

    redirect_to new_import_path, notice: result
  end

  def upload_csv
    if params[:csv_file]
      @bad_items = ImportCsv.call(params[:csv_file].read.force_encoding('UTF-8'))
      if @bad_items.!empty?
        render :csv_errors
      else
        redirect_to '/items'
      end
    else
      render inline: 'Unprocessable entity', status: :unprocessable_entity
    end
  end
end
