const wk8 = r"""
const metadata = {
  name: '轻小说文库',
  uuid: '352561f8-281c-4953-81f7-3772c6285c1c',
  baseUrl: 'http://app.wenku8.com/android.php',
  userAgent:
    ' Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36(KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
  author: 'Nexw',
  version:"1.0.0",
}
const _APPVER = '1.13'
const forms = [
  {
    title: '用户登录',
    description: '你可以直接设置 Cookies，也可以填写账号密码后手动登录生成，二选一即可，最终以 Cookies 字段的值为准',
    fields: [
      {
        fieldType: 'input',
        field: 'username',
        label: '用户名',
        placeholder: '请输入用户名',
      },
      {
        fieldType: 'input',
        field: 'password',
        label: '密码',
        password: true,
        placeholder: '请输入密码',
      },
      {
        fieldType: 'button',
        field: 'login',
        label: '登录',
      },
      {
        fieldType: 'input',
        field: 'cookies',
        label: 'Cookies',
        password: true,
        placeholder: '设置 Cookies',
      },
    ],
  },
]
const actions = []
const post = (params) => {
  const request = params.toQuery().toBase64()
  const timeStamp = new Date().getTime()
  return JReqwest.post(metadata.baseUrl, {
    headers: {
      'User-Agent': metadata.userAgent,
    },
    form: {
      appver: _APPVER,
      request,
      timetoken: timeStamp * 1000,
    },
  })
}
const login = () => {
  const uname = encodeURI(__ENVS__.username)
  const pwd = encodeURI(__ENVS__.password)
  const res = post({
    action: 'login',
    username: uname,
    password: pwd,
  })
  if (res.body == 1) {
    __ENVS__.cookies = res.headers['set-cookie']
    return JSON.stringify(__ENVS__)
  } else {
    return null
  }
}
const search = (params) => {
  const { key, page = 0, count = 10 } = params
  const res = post({
    action: 'search',
    searchtype: 'articlename',
    searchkey: key,
    t: 0,
  })
  const { ok, body } = res
  if (ok) {
    const resp = xml2Json(body)
    const arrs =
      resp.result.item instanceof Array ? resp.result.item : [resp.result.item]
    return arrs.map(({ aid, data }) => ({
      id: String(aid),
      name: data[0].text,
      author: data[4].value,
      cover: getCover(aid),
      description: data[8].text,
      status: data[5].value === '连载中' ? '0' : '1',
      tags: data[7].value.split(' '),
      last_update_time: data[6].value,
    }))
  }
  return []
}
const getCover = (aid) => {
  const ia = parseInt(aid, 10)
  return `https://img.wenku8.com/image/${Math.floor(
    ia / 1000
  )}/${aid}/${aid}s.jpg`
}
const detail = ({ bid }) => {
  const res = post({
    action: 'book',
    do: 'meta',
    aid: bid,
    t: 0,
  })
  const { body: intro } = post({
    action: 'book',
    do: 'intro',
    aid: bid,
    t: 0,
  })
  const data = xml2Json(res.body).metadata.data
  return {
    id: bid,
    name: data.find((item) => item.name === 'Title').text,
    author: data.find((item) => item.name === 'Author').value,
    description:intro,
    wordCount: data.find((item) => item.name === 'BookLength').value,
    cover: getCover(bid),
    copyright: data.find((item) => item.name === 'PressId').value,
    status: data.find((item) => item.name === 'BookStatus').value === '连载中' ? '0' : '1',
    lastUpdate: data.find((item) => item.name === 'LastUpdate').value,
    latestChapter: {
      id: data.find((item) => item.name === 'LatestSection').cid+"",
      name: data.find((item) => item.name === 'LatestSection').text,
    },
    extraDatas: [
      {
        label: '总点击',
        value: data.find((item) => item.name === 'TotalHitsCount').value+"",
      },
      {
        label: '推荐数',
        value: data.find((item) => item.name === 'PushCount').value+"",
      },
      {
        label: '收藏数',
        value: data.find((item) => item.name === 'FavCount').value+"",
      },
    ],
  }
}
const catalog = ({ bid }) => {
  const res = post({
    action: 'book',
    do: 'list',
    aid: bid,
    t: 0,
  })
  const obj = xml2Json(res.body)
  let volumes = obj.package.volume
  if (!(volumes instanceof Array)) {
    volumes = [volumes]
  }
  return volumes.map(({ chapter, text, vid }) => ({
    id: String(vid),
    name: text,
    chapters: chapter.map(({ cid, text }) => ({
      name: text,
      id: String(cid),
      isVip: false,
      canRead: true,
    })),
  }))
}
const chapter = ({ bid, cid }) => {
  const res = post({
    action: 'book',
    do: 'text',
    aid: bid,
    cid: cid,
    t: 0,
  })
  return {
    id: cid,
    content: res.body.split('\n\n\n')[1],
  }
}

const test = () => {
  console.log('wenku8 test')
  console.log({
    a: 1,
    b: '2',
    c: 3,
  })
}

""";
