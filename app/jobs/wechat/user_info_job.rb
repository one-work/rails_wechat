# frozen_string_literal: true

module Wechat
  class UserInfoJob < ApplicationJob

    def perform(wechat_user, limit)
      wechat_user.sync_user_info(limit)
    end

  end
end
