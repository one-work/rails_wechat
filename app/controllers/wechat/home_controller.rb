module Wechat
  class HomeController < BaseController
    after_action :delete_frame_header, only: [:glodplan]

    def glodplan
    end

    private
    def delete_frame_header
      response.headers.delete('X-Frame-Options')
    end

  end
end
