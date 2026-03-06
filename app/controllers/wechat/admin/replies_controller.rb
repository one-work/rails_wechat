module Wechat
  class Admin::RepliesController < Admin::BaseController
    before_action :set_app
    before_action :set_reply, only: [:show, :edit, :add, :update, :destroy]
    before_action :set_new_reply, only: [:new, :build, :create]

    def index
      q_params = {}
      q_params.merge! params.permit(:type)

      @replies = @app.replies.template.default_where(q_params).page(params[:page])
    end

    def build
      if @reply.is_a?(NewsReply)
        @reply.news_reply_items.build
      end
    end

    def add
      @reply.news_reply_items.build
    end

    private
    def set_reply
      @reply = @app.replies.find(params[:id])
    end

    def set_new_reply
      @reply = @app.replies.build(reply_params)
    end

    def reply_params
      params.fetch(:reply, {}).permit(
        :type,
        :title,
        :description,
        :value,
        :media,
        news_reply_items_attributes: {}
      )
    end

  end
end
