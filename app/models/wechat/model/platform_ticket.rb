module Wechat
  module Model::PlatformTicket
    extend ActiveSupport::Concern

    included do
      attribute :signature, :string
      attribute :timestamp, :integer
      attribute :nonce, :string
      attribute :msg_signature, :string
      attribute :appid, :string
      attribute :ticket_data, :string
      attribute :message_hash, :json
      attribute :info_type, :string

      belongs_to :platform, foreign_key: :appid, primary_key: :appid, optional: true

      before_save :parse_data, if: -> { ticket_data_changed? }
      after_create_commit :disable_app, if: -> { ['unauthorized'].include?(info_type) }
    end

    def disable_app
      app = App.find_by appid: message_hash['AuthorizerAppid']
      app&.update enabled: false
    end

    def parse_data
      content = platform.decrypt(ticket_data)
      data = Hash.from_xml(content).fetch('xml', {})
      self.message_hash = data
      self.info_type = data['InfoType']

      r = message_hash['ComponentVerifyTicket']
      if r.present? && platform.present?
        platform.verify_ticket = r
        platform.save
      end
    end

    def clean_last
      self.class.where(appid: appid, info_type: info_type).where.not(id: id).delete_all
    end

  end
end
