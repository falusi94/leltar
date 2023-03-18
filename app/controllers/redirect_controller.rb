# frozen_string_literal: true

class RedirectController < ApplicationController
  def show
    return redirect_to items_path if current_user.admin

    groups = current_user.read_groups

    if groups.none?
      unauthorized_page
    elsif groups.count > 1
      redirect_to items_path
    else
      redirect_to group_items_path(groups.first.id)
    end
  end
end
