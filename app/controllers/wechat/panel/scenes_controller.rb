module Wechat
  class Panel::ScenesController < Panel::BaseController
    before_action :set_app
    before_action :set_scene, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_scene, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! params.permit(:handle_type, :handle_id, :match_value, :state_uuid)

      @scenes = @app.scenes.includes(:response).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def sync
      r= @app.api.menu_create @app.menu
      render 'sync', locals: { notice: r.to_s }
    end

    private
    def set_scene
      @scene = @app.scenes.find(params[:id])
    end

    def set_new_scene
      @scene = @app.scenes.build(scene_params)
    end

    def filter_columns
      {
        'match_value' => { type: 'search', default: true },
        'state_uuid' => { type: 'search', default: true }
      }
    end

    def scene_params
      params.fetch(:scene, {}).permit(
        :match_value,
        :env_version,
        :expire_seconds
      )
    end

  end
end
