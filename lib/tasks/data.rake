namespace :data do
  desc "TODO"
  task :add_groups, [:filename] => :environment do |t, args|
    group_names = IO.readlines(args[:filename])
    group_names = group_names.map { |name| name.chomp }
    group_names.each do |name|
      Group.create(name: name)
    end
  end

  task :add_images, [:directory] => :environment do |t, args|
    files = Dir.entries(args[:directory])
    files = files.keep_if { |f| f =~ /.jpg$/i }
    files.each do |f|
      begin
        number = f.split('_')[0]
        number = Integer(number)
        items = Item.where(old_number: number)
        if items.size == 1
          file = File.open(args[:directory]+f)
          Photo.create(item: items.first, file: file)
        elsif items.size == 0
          puts "Item not found for #{f}"
        else
          puts "Multiple items found for #{f}"
        end
      rescue => e
        puts "Error inserting #{f}"
        puts e.inspect
      end
    end
  end
end
