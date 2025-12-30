module Wechat
  class SessionChannel < ApplicationCable::Channel
    #after_subscribe :refresh_qrcode

    def subscribed
      stream_from "wechat:session:#{session_id}"
      refresh_qrcode
    end

    private
    def refresh_qrcode
      provider_app = organ&.provider&.app || App.global.take
      if provider_app
        scene = provider_app.scenes.find_or_initialize_by(match_value: "session_#{session_id}")
        scene.expire_seconds = 600 # 默认 600 秒有效
        scene.check_refresh
        scene.aim = 'login'
        scene.state_uuid = params[:state] if params[:state].present?
        scene.broadcast_to = session_id
        scene.save
      end
    end

  end
end
