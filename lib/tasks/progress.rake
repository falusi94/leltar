namespace :progress do
  desc "TODO"
  task group: :environment do
    res = Group.all.map do |grp|                                                                                                                            
      all = grp.items.count
      done = grp.items.where('last_check is not null').count
      "#{grp.name}\t#{done}\t#{all}\t#{100.0*done/all}"
    end
    File.open('group_progress.tsv', 'w') { |f| f.write(res.join("\t")) }
  end

end
