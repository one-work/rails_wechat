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
        if key == 'first' && value[:value].blank?  # todo 这个逻辑好像微信不支持了，可以删除了
          r.merge! key => { value: notification.title }
        elsif value[:value] == 'sending_at'
          if notification.sending_at
            r.merge! key => { value: notification.sending_at.to_fs(:wechat) }
          else
            r.merge! key => { value: notification.created_at.to_fs(:wechat) }
          end
        else
          text = notification.notifiable_detail[value[:value]]

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
