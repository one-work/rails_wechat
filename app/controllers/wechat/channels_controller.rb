module Wechat
  class ChannelsController < BaseController

    def index
      @channels = Channel.page(params[:page])
    end

  end
end
