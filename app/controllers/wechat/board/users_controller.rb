module Wechat
  class Board::UsersController < My::UsersController
    before_action :set_scene

    def invite_qrcode
      @requests = @scene.requests.includes(:wechat_user).order(id: :desc).page(params[:page])
    end

    private
    def set_scene
      @scene = current_user.invite_user!(current_wechat_app, organ_id: nil)
    end

  end
end
