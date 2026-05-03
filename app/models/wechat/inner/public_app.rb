# frozen_string_literal: true

module Wechat
  module Inner::PublicApp
    extend ActiveSupport::Concern

    included do
      attribute :oauth_enable, :boolean, default: true
    end

    def domain
      organ&.host || webview_domain
    end

    def api
      return @api if defined? @api
      @api = Wechat::PublicApi.new(self)
    end

    def sync_menu
      api.menu_delete
      api.menu_create menu
    end

    def menu_roots
      menu_roots = MenuRoot.includes(:menus).all.group_by(&:position)
      menu_root_apps = menu_root_apps.group_by(&:position)
      [1, 2, 3].each_with_object({}) do |position, h|
        h.merge! position => menu_root_apps.fetch(position, []) + menu_roots.fetch(position, [])
      end
    end

    def menu
      r = menu_roots.map do |menu_root|
        _subs = menu_root.app_menus(self).delete_if { |i| i.disabled_id.present? }


        subs = _subs[0..4].as_json(host: domain.split(':')[0])
        if subs.size <= 1
          subs[0]
        else
          { name: menu_root.name, sub_button: subs }
        end
      end.compact

      { button: r[0..2] }
    end

    def js_config(url = '/')
      refresh_jsapi_ticket unless jsapi_ticket_valid?
      js_hash = Wechat::Signature.signature(jsapi_ticket, url)
      js_hash.merge! appid: appid
      logger.debug "\e[35m  Current page is: #{url}, Hash: #{js_hash.inspect}  \e[0m"
      js_hash
    rescue => e
      logger.debug e.message
      {}
    end

    def update_open_appid!
      r = api.open_get
      if r['errcode'] == 0
        self.update open_appid: r['open_appid']
      else
        r = api.open_create
        self.update open_appid: r['open_appid']
      end
    end

  end
end
