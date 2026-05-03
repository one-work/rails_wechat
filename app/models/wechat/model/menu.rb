module Wechat
  module Model::Menu
    extend ActiveSupport::Concern
    include Inner::Menu

    TYPE = {
      'view' => 'Wechat::ViewMenu',
      'click' => 'Wechat::ClickMenu',
      'miniprogram' => 'Wechat::MiniProgramMenu',
      'scancode_push' => 'Wechat::ScanPushMenu',
      'scancode_waitmsg' => 'Wechat::ScanWaitMenu'
    }.freeze

    included do
      attr_accessor :final_position
      attr_accessor :disabled_id

      attribute :root_position, :integer
      attribute :position, :integer

      positioned on: [:root_position]

      #after_save_commit :sync_to_wechat, if: -> { (saved_changes.keys & ['name', 'value', 'mp_appid', 'mp_pagepath']).present? }
    end

    def sync_to_wechat
      scenes.each do |scene|
        scene.sync_menu
      end
    end

  end
end
