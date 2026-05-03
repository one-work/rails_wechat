module Wechat
  module Model::MenuRootApp
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :appid, :string
      attribute :position, :integer

      belongs_to :app, foreign_key: :appid, primary_key: :appid

      has_many :menus, primary_key: :position, foreign_key: :root_position
      has_many :menu_apps, primary_key: [:appid, :position], foreign_key: [:appid, :root_position]

      validates :position, inclusion: [1, 2, 3]
    end

    def app_menus(_ = nil)
      disabled_ids = app.menu_disables.pluck(:menu_id, :id).to_h

      r = []
      r.concat menus.each { |i| i.disabled_id = disabled_ids[i.id] }
      r.concat menu_apps
      r.sort_by!(&:final_position)
      r
    end

  end
end
