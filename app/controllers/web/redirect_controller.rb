# frozen_string_literal: true

module Web
  class RedirectController < BaseController
    def show
      return redirect_to items_path if current_user.admin

      departments = current_user.departments.with_read_access

      if departments.none?
        unauthorized_page
      elsif departments.count > 1
        redirect_to items_path
      else
        redirect_to department_items_path(departments.first.id)
      end
    end
  end
end
