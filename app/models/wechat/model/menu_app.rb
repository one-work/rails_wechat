module Wechat
  module Model::MenuApp
    extend ActiveSupport::Concern
    include Inner::Menu

    included do
      attribute :appid, :string, index: true
      attribute :root_position, :integer
      attribute :menu_position, :integer
      attribute :position, :integer

      belongs_to :app, foreign_key: :appid, primary_key: :appid

      belongs_to :scene, optional: true
      belongs_to :tag, optional: true

      positioned on: [:root_position, :menu_position, :appid]
    end

    def final_position
      menu_position * 10 + position
    end

    def xx
      if options[:app]
        host = options[:app].domain.presence || options[:app].organ.host.presence || Rails.application.routes.default_url_options[:host]
      else
        host = app&.domain.presence || organ&.host.prescen || Rails.application.routes.default_url_options[:host]
      end
    end

  end
end
