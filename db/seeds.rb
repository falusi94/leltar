# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: 'admin',
  email: 'admin@example.org',
  password_digest: User.digest('foobar'),
  admin: true
) unless User.exists?(email: 'admin@example.org')

{
  new_session_start:            1.year.ago,
  depreciation_method:          :straight_line_depreciation,
  depreciation_frequency_unit:  :year,
  depreciation_frequency_value: 1
}.each do |name, value|
  SystemAttribute.create!(name: name, value: value) unless SystemAttribute.exists?(name: name)
end

unless Department.exists?(name: 'Management')
  ActiveRecord::Base.transaction do
    department = Department.create!(name: 'Management')

    printer = Item.create!(
      accountancy_state: :in_register,
      condition:         :used,
      inventory_number:  '666',
      entry_date:        1.year.ago,
      entry_price:       600,
      last_check:        Time.zone.today,
      location:          'Office 1',
      name:              'Printer',
      number:            1,
      purchase_date:     1.year.ago,
      serial:            'printer-serial',
      status:            :ok,
      warranty:          2.years.from_now,
      department:             department,
    )
    photo = File.open(Rails.root.join('db/fixtures/printer.jpg'))
    printer.photos.attach(io: photo, filename: 'printer.jpg', content_type: 'image/jpeg')

    broken_printer = Item.create!(
      accountancy_state: :in_register,
      condition:         :end_of_life,
      inventory_number:  '100',
      entry_date:        5.years.ago,
      entry_price:       450,
      last_check:        1.year.ago,
      location:          'Office 1',
      name:              'Printer',
      number:            1,
      purchase_date:     5.years.ago,
      serial:            'old-printer-serial',
      status:            :scrapped,
      warranty:          3.years.ago,
      department:             department
    )
    photo = File.open(Rails.root.join('db/fixtures/broken-printer.jpg'))
    broken_printer.photos.attach(io: photo, filename: 'broken-printer.jpg', content_type: 'image/jpeg')
  end
end

unless Department.exists?(name: 'Development')
  ActiveRecord::Base.transaction do
    department = Department.create!(name: 'Development')

    pc = Item.create!(
      accountancy_state: :new,
      condition:         :ok,
      inventory_number:  '42',
      entry_date:        Time.zone.today,
      entry_price:       1900,
      last_check:        Time.zone.today,
      location:          'Office 2',
      name:              'PC',
      number:            1,
      purchase_date:     Time.zone.today,
      serial:            'pc-serial',
      status:            :ok,
      department:             department
    )
    photo = File.open(Rails.root.join('db/fixtures/barbone.jpg'))
    pc.photos.attach(io: photo, filename: 'barbone.jpg', content_type: 'image/jpeg')

    { barbone: 1500, memory: 200, ssd: 200 }.each_with_index do |(part, price), index|
      Item.create!(
        accountancy_state: :new,
        condition:         :ok,
        inventory_number:  "42-#{index}",
        entry_date:        Time.zone.today,
        entry_price:       price,
        last_check:        Time.zone.today,
        location:          'Office 2',
        name:              part.to_s.humanize,
        number:            1,
        purchase_date:     Time.zone.today,
        serial:            "#{part}-serial",
        status:            :ok,
        warranty:          3.years.from_now,
        department:             department,
        parent:            pc
      )
    end
  end
end
