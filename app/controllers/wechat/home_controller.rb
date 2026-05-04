module Wechat
  class HomeController < BaseController
    after_action :delete_frame_header, only: [:glodplan]

    def glodplan
      real_id, _ = params[:out_trade_no].to_s.split('_')
      if real_id
        @order = Trade::Order.find_by(uuid: real_id)
        @order_url = url_for(controller: 'trade/my/orders', action: 'show', id: @order.id, host: @order.organ.host)
      end
    end

    private
    def delete_frame_header
      response.headers.delete('X-Frame-Options')
    end

  end
end
