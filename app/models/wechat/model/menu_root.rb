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
      r = menus.to_a
      menu_apps.includes(:menu).where(appid: appid).order(position: :desc).each do |menu_app|
        if menu_app.menu
          r.insert r.index(menu_app.menu) + 1, menu_app
        else
          r.insert -(r.size + 1), menu_app
        end
      end
      r
    end

  end
end
