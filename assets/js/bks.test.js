const guestLoginAction = async () => {
  console.log('guest loginAction')
}

return {
  favIcon:
    'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://www.ciweimao.com&size=24',
  name: '刺猬猫阅读',
  author: 'zsakvo',
  actions: [
    {
      label: '游客登录',
      icon: 'account_circle',
      action: guestLoginAction,
    },
  ],
  forms: [
    {
      title: '账户设置',
      subtitle:
        '设定账你的户信息，请注意，请至少设置一个账户 token 或者生成一个游客账号，否则无法启用',
      form: [
        {
          type: 'input',
          field: 'token',
          title: 'Token',
          placeholder: '请输入 Token',
        },
        {
          type: 'input',
          field: 'account',
          title: '用户名',
          placeholder: '书客xxxxxx',
        },
        {
          type: 'input',
          field: 'ua',
          title: 'UserAgent',
          placeholder: '请输入 UserAgent',
        },
      ],
    },
    {
      title: '代理设置',
      subtitle: '设置代理，如果你需要通过代理访问，请设置代理',
      form: [
        {
          type: 'input',
          field: 'proxy',
          title: '代理',
          placeholder: 'socks5://localhost:3721',
        },
      ],
    },
  ],
}
