# frozen_string_literal: true

module Web
  class RightsController < BaseController
    before_action -> { authorize(Right) }

    def create
      right = Right.new(right_params)

      if right.save
        redirect_back fallback_location: root_path, notice: t('success.create')
      else
        redirect_back fallback_location: root_path, alert: t(:error_during_save)
      end
    end

    def update
      right.write = !right.write

      if right.save
        redirect_back fallback_location: root_path, notice: t('success.edit')
      else
        redirect_back fallback_location: root_path, alert: t(:error_during_save)
      end
    end

    def destroy
      right.destroy

      redirect_back fallback_location: root_path, notice: t('success.delete')
    end

    private

    def right
      @right ||= Right.find(params[:id])
    end

    def right_params
      params.require(:right).permit(:group_id, :user_id, :write)
    end
  end
end
