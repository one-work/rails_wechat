module Wechat
  module Model::PayeeDomain
    extend ActiveSupport::Concern

    included do
      attribute :mch_id, :string, index: true
      attribute :domain, :string, index: true

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :organ_domain, class_name: 'Org::OrganDomain', foreign_key: :domain, primary_key: :host, optional: true

      belongs_to :payee, foreign_key: :mch_id, primary_key: :mch_id
    end

  end
end
