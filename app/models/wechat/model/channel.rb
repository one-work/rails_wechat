module Wechat
  module Model::Channel
    extend ActiveSupport::Concern

    included do
      attribute :feed_id, :string
      attribute :finder_user_name, :string
      attribute :feed_token, :string
      attribute :autoplay, :boolean, default: true
      attribute :looped, :boolean, default: true

      belongs_to :app, foreign_key: :appid, primary_key: :appid
    end

  end
end
