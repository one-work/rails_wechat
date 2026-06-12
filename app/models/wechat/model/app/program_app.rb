module Wechat
  module Model::App::ProgramApp

    def template_messenger(template)
      Wechat::Message::Template::Program.new(self, template)
    end

  end
end
