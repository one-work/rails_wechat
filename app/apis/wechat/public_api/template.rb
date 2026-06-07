class Wechat::PublicApi
  module Template
    BASE = 'https://api.weixin.qq.com/cgi-bin/'

    def industry
      r = get 'template/get_industry', origin: BASE
    end

    def industry_set(industry_id1, industry_id2)
      post 'template/api_set_industry', industry_id1: industry_id1, industry_id2: industry_id2, origin: BASE
    end

    def templates
      r = get 'template/get_all_private_template', origin: BASE
      r['template_list']
    end

    def add_template(template_id_short, *list)
      post(
        'template/api_add_template',
        template_id_short: template_id_short,
        keyword_name_list: list,
        origin: BASE
      )
    end

    def del_template(template_id)
      post 'template/del_private_template', template_id: template_id, origin: BASE
    end

  end
end
