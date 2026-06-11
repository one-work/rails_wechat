module Wechat
  module Ext::Member
    extend ActiveSupport::Concern
    include Ext::Handle

    included do
      attribute :corp_userid, :string

      belongs_to :member_inviter, class_name: 'Org::Member', optional: true

      has_many :corp_users, ->(o) { where(organ_id: o.organ_id) }, class_name: 'Wechat::CorpUser', primary_key: :corp_userid, foreign_key: :userid
      has_many :wechat_users, class_name: 'Wechat::WechatUser', primary_key: :identity, foreign_key: :identity
      has_many :program_users, class_name: 'Wechat::ProgramUser', primary_key: :identity, foreign_key: :identity
      has_many :medias, class_name: 'Wechat::Media'
      has_many :subscribes, -> { where(sending_at: nil) }, class_name: 'Wechat::Subscribe', through: :program_users
      has_many :scenes, as: :handle, class_name: 'Wechat::Scene'
    end

    def invite_member!
      app = organ.provider&.app || App.global.take

      if app
        scene = scenes.find_or_initialize_by(appid: app.appid, organ_id: organ_id, aim: 'invite_member')
        scene.check_refresh
        scene.save
        scene
      end
    end

    def invite_contact!(tag_name)
      app = organ.provider&.app || App.global.take

      if app
        scene = scenes.find_or_initialize_by(appid: app.appid, organ_id: organ_id, aim: 'invite_contact', tag_name: tag_name)
        scene.check_refresh
        scene.save
        scene
      end
    end

  end
end
