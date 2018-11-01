# frozen_string_literal: true

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
      next unless group_id

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
    children = []
    sheet.parse.each do |row|
      at_who = lookup_at_who(row[7])
      item = Item.create(
        group_id: group_id,
        name: row[0],
        specific_name: row[1],
        description: row[2],
        serial: row[3],
        location: row[4],
        status: at_who.nil? ? lookup_status(row[5]) : :at_group_member,
        condition: lookup_condition(row[6]),
        at_who: at_who,
        warranty: lookup_warranty(row[9]),
        organization: lookup_organization(row[10]),
        comment: row[11]
      )
      parent_serial = row[8]
      children.push({ parent_serial: parent_serial, item: item }) if parent_serial.present?
      success_count += 1 if item
      error_count += 1 unless item
    end
    update_parents(children)
    [success_count: success_count, error_count: error_count]
  end

  def lookup_status(input)
    status = {
      ok: 'OK',
      waiting_for_repair: 'javításra vár',
      waiting_for_scrapping: 'selejtezésre vár',
      scrapped: 'selejtezve',
      not_found: 'eltűnt',
      at_group_member: '',
      other: 'egyéb probléma'
    }.invert[input]
    status || :other
  end

  def lookup_condition(input)
    condition = {
      ok: 'jó állapotban van',
      used: 'használt',
      end_of_life: 'EOL',
      not_working: 'funkcióját nem látja el'
    }.invert[input]
    condition || :ok
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

  def update_parents(children)
    children.each do |child|
      parent = Item.find_by serial: child[:parent_serial]
      child[:item].update parent: parent if parent
    end
  end
end
