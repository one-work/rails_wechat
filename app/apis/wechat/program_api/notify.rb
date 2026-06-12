class Wechat::ProgramApi
  module Notify
    BASE = 'https://api.weixin.qq.com/wxa/'


    def notify_set
      post 'set_user_notify'
    end

    def notify_ext

    end

    def notify_get

    end

  end
end
