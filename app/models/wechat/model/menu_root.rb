module Wechat
  module Model::MenuRoot
    extend ActiveSupport::Concern

    included do
      attr_accessor :final_position

      attribute :name, :string
      attribute :position, :integer

      has_many :menus, -> { order(position: :asc) }, primary_key: :position, foreign_key: :root_position
      has_many :menu_apps, -> { order(position: :asc) }, primary_key: :position, foreign_key: :root_position

      validates :position, inclusion: [1, 2, 3]
    end

    def app_menus(appid)
      r = []
      r.concat menus.each { |i| i.final_position = i.position * 10 }
      r.concat menu_apps.where(appid: appid).each { |i| i.final_position = i.menu_position * 10 + i.position }
      r
    end

  end
end
