module Wechat
  class Panel::ChannelsController < Panel::BaseController
    before_action :set_app

    def index
      @channels = @app.channels.default_where(q_params).order(id: :asc).page(params[:page])
    end

  end
end
