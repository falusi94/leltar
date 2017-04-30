module GroupsHelper
  def group_items_path(group)
    "groups/#{group.name}"
  end
end
