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

    def app_menus(app)
      disabled_ids = app.menu_disables.where(appid: app.appid).pluck(:menu_id, :id).to_h

      r = []
      r.concat menus.each { |i| i.disabled_id = disabled_ids[i.id] }
      r.concat app.menu_apps
      r.sort_by!(&:final_position)
      r
    end

  end
end
