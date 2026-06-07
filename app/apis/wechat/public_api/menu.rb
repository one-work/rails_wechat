class Wechat::PublicApi
  module Menu
    BASE = 'https://api.weixin.qq.com/cgi-bin/'

    def menu
      get 'menu/get', origin: BASE
    end

    def menu_delete
      get 'menu/delete', origin: BASE
    end

    def menu_create(menu)
      post 'menu/create', button: menu, origin: BASE
    end

    def menu_addconditional(menu)
      post 'menu/addconditional', **menu, origin: BASE
    end

    def menu_trymatch(user_id)
      post 'menu/trymatch', user_id: user_id, origin: BASE
    end

    def menu_delconditional(menuid)
      post 'menu/delconditional', menuid: menuid, origin: BASE
    end

  end
end
