# based on:
# https://github.com/danmactough/node-feedparser/blob/master/examples/iconv.js
#
FeedParser = require('feedparser')
request    = require('request')
Iconv      = require('iconv').Iconv


getParams = (str) ->
  params = str.split(';').reduce(((params, param) ->
    parts = param.split('=').map (part) -> return part.trim()
    if parts.length == 2
      params[parts[0]] = parts[1]
    return params
  ), {})
  return params


module.exports = class Parser
  constructor: (@urls, callback) ->
    @posts = {}
    @onFeched = _after @urls.length, => callback(@posts)

    @urls.map (url) =>
      @posts[url] = []
      @fetch(url)

  fetch: (url) ->
    # Define our streams
    req = request(url, {timeout: 10000, pool: false})
    req.setMaxListeners(50)
    # Some feeds do not respond without user-agent and accept headers.
    req.setHeader('user-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36').setHeader('accept', 'text/html,application/xhtml+xml')

    feedparser = new FeedParser()

    # Define our handlers
    req.on 'error', => @done()
    req.on 'response', (res) ->
      stream = this

      if res.statusCode != 200 then return this.emit('error', new Error('Bad status code'))

      charset = getParams(res.headers['content-type'] || '').charset

      # Use iconv if its not utf8 already.
      if !iconv && charset && !/utf-*8/i.test(charset)
        try
          iconv = new Iconv(charset, 'utf-8')
          console.log('Converting from charset %s to utf-8', charset)
          iconv.on 'error', => @done()
          # If we're using iconv, stream will be the output of iconv
          # otherwise it will remain the output of request
          stream = this.pipe(iconv)
        catch err
          this.emit('error', err)

      # And boom goes the dynamite
      stream.pipe(feedparser)

    feedparser.on 'error', => @done()
    feedparser.on 'end', => @done()

    posts = @posts
    feedparser.on 'readable', ->
      while (post = this.read())
        posts[url].push({ title: post.title, link: post.link })

  done: (err) ->
    if err then console.log(err, err.stack)
    @onFeched()