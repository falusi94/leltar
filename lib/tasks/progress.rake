namespace :progress do
  desc "TODO"
  task group: :environment do
    res = Group.all.map do |grp|                                                                                                                            
      all = grp.items.count
      done = grp.items.where('last_check is not null').count
      "#{grp.name}\t#{done}\t#{all}\t#{100.0*done/all}"
    end
    File.open('group_progress.tsv', 'w') { |f| f.write(res.join("\n")) }
  end

  task group_status: :environment do
    res = Group.all.map do |grp|
      all = grp.items.count
      done = grp.items.where('last_check is not null').count
      status_counts = Item.VALID_STATUS.map do |status|
        grp.items.where(status: status).count
      end
      ([grp.name, all, done] + status_counts).join("\t")
    end
    File.open('status_report.tsv', 'w') do |f|
      f.write("Kor\tOsszes\tLeltarozva\t"+Item.VALID_STATUS.join("\t")+"\n")
      f.write(res.join("\n")) 
    end
  end

end
