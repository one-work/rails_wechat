module Wechat
  class Panel::ChannelsController < Panel::BaseController
    before_action :set_app
    before_action :set_new_channel, only: [:new, :create]

    def index
      q_params = {}

      @channels = @app.channels.default_where(q_params).order(id: :asc).page(params[:page])
    end

    private
    def set_new_channel
      @channel = @app.channels.build(channel_params)
    end

    def channel_params
      params.fetch(:channel, {}).permit(
        :feed_id,
        :feed_token,
        :autoplay
      )
    end

  end
end
