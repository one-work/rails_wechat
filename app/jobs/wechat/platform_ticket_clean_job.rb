module Wechat
  class PlatformTicketCleanJob < ApplicationJob

    def perform
      PlatformTicket.where(info_type: 'component_verify_ticket').delete_all
    end

  end
end
