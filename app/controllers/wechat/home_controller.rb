module Wechat
  class HomeController < BaseController
    after_action :delete_frame_header, only: [:glodplan]

    def glodplan
      real_id, _ = params[:out_trade_no].split('_')
      @order = Trade::Order.find_by(uuid: real_id)
    end

    private
    def delete_frame_header
      response.headers.delete('X-Frame-Options')
    end

  end
end
