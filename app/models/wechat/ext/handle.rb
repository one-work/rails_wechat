module Wechat
  module Ext::Handle
    extend ActiveSupport::Concern

    included do
      has_many :scenes, as: :handle, class_name: 'Wechat::Scene'
    end

    def to_scene!(appid)
      scene = scenes.find_or_initialize_by(appid: appid)
      scene.refresh if scene.expired?
      scene.save
      scene
    end

  end
end
