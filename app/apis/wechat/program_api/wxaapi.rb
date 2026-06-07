class Wechat::ProgramApi
  module Wxaapi
    BASE = 'https://api.weixin.qq.com/wxaapi/'

    # https://developers.weixin.qq.com/miniprogram/dev/api-backend/open-api/template-message/templateMessage.getTemplateList.html
    def tmpl_templates
      r = get 'newtmpl/gettemplate', origin: BASE
      if r['errcode'] == 0
        r['data']
      else
        Rails.logger.info r
        r
      end
    end

    def tmpl_categories
      get 'newtmpl/getcategory', origin: BASE
    end

    def pub_templates(*ids, start: 0, limit: 30, **options)
      r = ids.join(',')
      puts r
      get 'newtmpl/getpubtemplatetitles', ids: r, start: start, limit: limit, origin: BASE, **options
    end

    # https://developers.weixin.qq.com/miniprogram/dev/api-backend/open-api/subscribe-message/subscribeMessage.getPubTemplateKeyWordsById.html
    def template_key_words(tid)
      r = get 'newtmpl/getpubtemplatekeywords', origin: BASE, tid: tid
      if r['errcode'] == 0
        r['data']
      else
        r
      end
    end

    def add_template(tid, kid_list, description: 'tst')
      post 'newtmpl/addtemplate', tid: tid, kidList: kid_list, sceneDesc: description, origin: BASE
    end

    def del_template(template_id)
      post 'newtmpl/deltemplate', origin: BASE, priTmplId: template_id
    end

  end
end
