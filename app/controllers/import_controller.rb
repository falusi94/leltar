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
    @results = import_helper.import(params)
  end
end
