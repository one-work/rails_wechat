module Wechat
  module Model::MenuRoot
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :position, :integer

      has_many :menus, -> { order(position: :asc) }, primary_key: :position, foreign_key: :root_position
      has_many :menu_apps, -> { order(position: :asc) }, primary_key: :position, foreign_key: :root_position

      validates :position, inclusion: [1, 2, 3]
    end

    def app_menus(appid)
      disabled_ids = menu_disables.where(appid: appid).map(&:menu_id)

      r = []
      r.concat menus.each { |i| i.final_position = i.position * 10; i.disabled = disabled_ids.include?(i.id) }
      r.concat menu_apps.where(appid: appid).each { |i| i.final_position = i.menu_position * 10 + i.position }
      r
    end

  end
end
