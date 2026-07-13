module Wechat
  module Model::Notice
    extend ActiveSupport::Concern

    included do
      attribute :link, :string
      attribute :msg_id, :string
      attribute :status, :string
      attribute :type, :string
      attribute :appid, :string
      attribute :open_id, :string
      attribute :result, :json

      belongs_to :notification, class_name: 'Notice::Notification'

      belongs_to :template
      belongs_to :app, foreign_key: :appid, primary_key: :appid
      belongs_to :wechat_user, foreign_key: :open_id, primary_key: :uid, optional: true
      belongs_to :msg_request, optional: true

      before_validation :sync_link, if: -> { notification_id.present? && notification_id_changed? }
      after_create_commit :do_send_later
    end

    def sync_link
      self.link = notification.link
    end

    def data
      r = {}
      template.data_mappings.each do |key, value|
        text = notification.notifiable_detail[value[:value]]
        if key == 'first' && value[:value].blank?
          r.merge! first: { value: notification.title }
        else
          if key.start_with?('time')
            r.merge! key => { value: text.to_datetime.to_fs(:wechat) }
          elsif key.start_with?('thing')
            r.merge! key => { value: text.truncate(20) }
          else
            r.merge! key => { value: text }
          end
        end
      end
      r
    end

    def do_send_later
      NoticeSendJob.perform_later(self)
    end

    def do_send
    end

  end
end
