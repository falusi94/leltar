require 'roo'
require 'chronic'

class ImportFromSheets
  def initialize(id)
    url = "https://docs.google.com/spreadsheets/d/#{id}/export?format=xlsx"
    @xlsx = Roo::Spreadsheet.open(url, extension: :xlsx, headers: true)
  end

  def sheets
    @xlsx.sheets.map { |sheet| [sheet.underscore, sheet] }
  end

  def import(params)
    result = []
    @xlsx.sheets.each do |sheet_name|
      group_id = params[sheet_name.underscore]
      return unless group_id
      sheet = @xlsx.sheet sheet_name
      count = import_sheet(sheet, group_id)
      result += [count: count, sheet: sheet_name]
    end
    result
  end

  private

  def import_sheet(sheet, group_id)
    success_count = 0
    error_count = 0
    sheet.parse.each do |row|
      success = Item.create(
        group_id: group_id,
        name: row[0],
        specific_name: row[1],
        description: row[2],
        serial: row[3],
        location: row[4],
        status: lookup_status(row[5]),
        condition: lookup_condition(row[6]),
        # TODO need to update status
        at_who: lookup_at_who(row[7]),
        # TODO lookup parent by serial row[8]
        warranty: lookup_warranty(row[9]),
        organization: lookup_organization(row[10]),
        comment: row[11],
      )
      success_count += 1 if success
      error_count += 1 unless success
    end
    [success_count: success_count, error_count: error_count]
  end

  def lookup_status(input)
    status = {
      :ok => 'OK',
      :waiting_for_repair => 'javításra vár',
      :waiting_for_scrapping => 'selejtezésre vár',
      :scrapped => 'selejtezve',
      :not_found => 'eltűnt',
      :at_group_member => '',
      :other => 'egyéb probléma',
    }.invert[input]
    status ||= :other
  end

  def lookup_condition(input)
    condition = {
      :ok => 'jó állapotban van',
      :used => 'használt',
      :end_of_life => 'EOL',
      :not_working => 'funkcióját nem látja el',
    }.invert[input]
    condition ||= :ok
  end

  def lookup_at_who(input)
    return nil if input&.empty? || input&.downcase == 'nem' || input&.downcase == 'nincs'
    input
  end

  def lookup_warranty(input)
    Chronic.parse input
  end

  def lookup_organization(input)
    return nil if input.nil?
    return :svie if input.downcase.include? 'svie'
    return :ska if input.downcase.include? 'ska'
    nil
  end
end
