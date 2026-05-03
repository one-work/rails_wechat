module Wechat
  class Panel::MenuAppsController < Panel::BaseController
    before_action :set_app
    before_action :set_menu_app, only: [:show, :edit, :update, :destroy]
    before_action :set_new_menu_app, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! params.permit(:name)

      menu_roots = MenuRoot.all.group_by(&:position)
      menu_root_apps = @app.menu_root_apps.group_by(&:position)
      @menu_roots = [1, 2, 3].each_with_object({}) do |position, h|
        h.merge! position => menu_root_apps.fetch(position, []) + menu_roots.fetch(position, [])
      end
    end

    def sync
      r = @app.sync_menu
      render 'alert_message', locals: { message: r.to_s }
    end

    private
    def set_menu_app
      @menu_app = @app.menu_apps.find(params[:id])
    end

    def set_new_menu_app
      @menu_app = @app.menu_apps.build(menu_params)
    end

    def set_types
      @types = Menu.options_i18n(:type)
    end

    def menu_params
      params.fetch(:menu_app, {}).permit(
        :menu_position,
        :root_position,
        :type,
        :name,
        :value,
        :mp_appid,
        :mp_pagepath
      )
    end

  end
end
