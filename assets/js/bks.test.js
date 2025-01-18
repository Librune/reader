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
      icon: 'ic_btn_satellite',
      action: guestLoginAction,
    },
    {
      label: '测试按钮 1',
      icon: 'ic_btn_satellite',
      action: guestLoginAction,
    },
    {
      label: '测试按钮 2',
      icon: 'ic_btn_satellite',
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
      title: '网络设置',
      subtitle: '设置代理，如果你需要通过代理访问，请设置代理',
      form: [
        {
          type: 'input',
          field: 'proxy',
          title: '代理',
          placeholder: '设定代理地址',
        },
        {
          type: 'input',
          field: 'proxy',
          title: '用户名',
          placeholder: '设定用户名',
        },
        {
          type: 'input',
          field: 'proxy',
          title: '密码',
          placeholder: '设定密码',
        },
      ],
    },
    {
      title: '杂项',
      subtitle: '一些额外的配置项目',
      form: [
        {
          type: 'toggle',
          field: 'log',
          title: '捕获日志',
          placeholder: '是否捕获并存储请求日志到本地',
        },
      ],
    },
  ],
}
