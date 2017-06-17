namespace :data do
  desc "TODO"
  task :add_groups, [:filename] => :environment do |t, args|
    group_names = IO.readlines(args[:filename])
    group_names = group_names.map { |name| name.chomp }
    group_names.each do |name|
      Group.create(name: name)
    end
  end

end
