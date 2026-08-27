module Wechat
  class Panel::PayeeDomainsController < Panel::BaseController
    before_action :set_payee
    before_action :set_payee_domain, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_payee_domain, only: [:new, :create]
    before_action :set_domains, only: [:new, :create, :edit, :update]

    def index
      q_params = {}

      @payee_domains = @payee.payee_domains.includes(organ_domain: :organ).default_where(q_params)
    end

    def organs
      if @payee.organ&.official?
        @organs = Organ.where(provider_id: [@payee.organ_id, nil]).page(params[:page])
      else
        @organs = @payee.organ.organs.page(params[:page])
      end
      @organ_ids = @payee.payee_domains.pluck(:domain_organ_id)
    end

    def add
      @organ = Organ.find params[:domain_organ_id]
      @organ.organ_domains.where(kind: ['frontend', 'mp']).each do |od|
        @payee.organ_domains.build(domain: od.host)
      end
      @payee.save
      @organ_ids = [@organ.id]
    end

    private
    def set_payee
      @payee = Payee.find params[:payee_id] || params[:partner_payee_id]
    end

    def set_payee_domain
      @payee_domain = @payee.payee_domains.find params[:id]
    end

    def set_new_payee_domain
      @payee_domain = @payee.payee_domains.build(payee_domain_params)
    end

    def set_domains
      @organ_domains = Org::OrganDomain.default_where(organ_id: @payee.organ.self_and_descendant_ids, kind: ['frontend', 'mp'])
    end

    def payee_domain_params
      params.fetch(:payee_domain, {}).permit(
        :domain
      )
    end
  end
end
