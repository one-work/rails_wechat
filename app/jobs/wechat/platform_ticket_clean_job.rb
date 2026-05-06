module Wechat
  class PlatformTicketCleanJob < ApplicationJob

    def perform
      PlatformTicket.where(info_type: 'component_verify_ticket')
    end

  end
end
