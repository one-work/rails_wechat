module Wechat
  module Model::PayeeDomain
    extend ActiveSupport::Concern

    included do
      attribute :mch_id, :string, index: true
      attribute :domain, :string, index: true

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :organ_domain, class_name: 'Org::OrganDomain', foreign_key: :domain, primary_key: :host, optional: true
      belongs_to :domain_organ, class_name: 'Org::Organ', optional: true

      belongs_to :payee, foreign_key: :mch_id, primary_key: :mch_id

      before_validation :init_domain_organ, if: -> { domain_changed? }
    end

    def init_domain_organ
      self.domain_organ = organ_domain.organ
    end

  end
end
