const name = '轻小说文库-r'
const author = 'Meow'
const version = '1.0.0'
const desc = '适配新版 boa 运行时的 wenku8 插件'
const id = 'ace1e456-8225-45b8-b430-88bece42bc33'

const _APPVER = '1.13'
const UA = 'Dalvik/2.1.0 (Linux; U; Android 11; IN2010 Build/RP1A.201005.001)'
const host = 'http://app.wenku8.com/android.php'

const forms = [
  {
    title: '账户设置',
    subtitle:
      '请填写轻小说文库账号信息，你可以直接设置 Cookies，也可以填写账号密码后手动登录生成，二选一即可，最终以 Cookies 字段的值为准',
    form: [
      {
        type: 'input',
        field: 'username',
        title: '用户名',
        placeholder: '请输入用户名',
      },
      {
        type: 'input',
        field: 'password',
        title: '密码',
        placeholder: '请输入密码',
      },
      {
        type: 'button',
        field: 'login',
        title: '登录',
      },
      {
        type: 'input',
        field: 'cookies',
        title: 'Cookies',
        placeholder: '设置 Cookies',
      },
    ],
  },
]

const actions = []

const post = (params) => {
  const request = params.toQuery().toBase64()
  const timeStamp = new Date().getTime()
  const resp = rq.post(host, {
    headers: {
      'User-Agent': UA,
      'Content-Type': 'application/x-www-form-urlencoded',
      charsets: 'utf-8',
      cookies: __ENVS__.cookies,
    },
    form: {
      appver: _APPVER,
      request,
      timetoken: timeStamp * 1000,
    },
  })
  return resp
}

const login = () => {
  const uname = encodeURI(__ENVS__.username)
  const pwd = encodeURI(__ENVS__.password)
  const res = post({
    action: 'login',
    username: uname,
    password: pwd,
  })
  console.log(JSON.stringify(res))
  if (res.body == 1) {
    __ENVS__.cookies = res.headers['set-cookie']
    return JSON.stringify(__ENVS__)
  } else {
    return null
  }
}

const search = ({ key, page, count }) => {
  const res = post({
    action: 'search',
    searchtype: 'articlename',
    searchkey: key,
    t: 0,
  })
  const resp = xml2Json(res.body)
  const arrs =
    resp.result.item instanceof Array ? resp.result.item : [resp.result.item]
  return arrs.map(({ aid, data }) => ({
    bookId: String(aid),
    name: data[0].text,
    author: data[4].value,
    cover: getCover(aid),
    description: data[8].text,
    creationStatus: data[5].value === '连载中' ? '1' : '0',
    tag: data[7].value.split(' '),
    update: data[6].value,
  }))
}

const catalog = ({ book_id }) => {
  const res = post({
    action: 'book',
    do: 'list',
    aid: book_id,
    t: 0,
  })
  const obj = xml2Json(res.body)
  return obj.package.volume.map(({ chapter, text, vid }) => ({
    vid: String(vid),
    title: text,
    chapters: chapter.map(({ cid, text }) => ({
      title: text,
      cid: String(cid),
      isVip: false,
      hasAccess: true,
    })),
  }))
}

const chapter = ({ chapter_id, book_id }) => {
  const res = post({
    action: 'book',
    do: 'text',
    aid: book_id,
    cid: chapter_id,
    t: 0,
  })
  return {
    content: res.body,
  }
}

const test = () => {
  return search({ key: '我的' })
}

const getCover = (aid) => {
  const ia = parseInt(aid, 10)
  return `https://img.wenku8.com/image/${Math.floor(
    ia / 1000
  )}/${aid}/${aid}s.jpg`
}
