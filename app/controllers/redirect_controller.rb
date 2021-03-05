# frozen_string_literal: true

class RedirectController < ApplicationController
  def show
    return redirect_to items_path if current_user.admin

    groups = current_user.read_groups
    return unauthorized_page if groups.size.zero?
    return redirect_to items_path if groups.size > 1

    redirect_to items_path, group_id: groups[0].id
  end
end
