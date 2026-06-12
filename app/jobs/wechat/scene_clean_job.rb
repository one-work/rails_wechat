module Wechat
  class SceneCleanJob < ApplicationJob

    def perform
      Scene.where(aim: 'login').expired.destroy_all
    end

  end
end
