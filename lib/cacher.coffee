module.exports = class Cacher
  constructor: (firebaseRef, feedsAndPosts, @callback) ->
    @cacheRef = firebaseRef.child('cache')
    @cacheRef.on 'value', (snapshot) =>
      @cacheRef.off()

      cache = snapshot.val()
      cache ?= []

      @feedsWithNewPosts = @getFeedsWithNewPosts(feedsAndPosts, cache)

      if @feedsWithNewPosts.length > 0
        console.log "feeds with new posts"
        console.log @feedsWithNewPosts

      @updateCache(feedsAndPosts)

  getFeedsWithNewPosts: (feedsAndPosts, cache) ->
    # reorganize cache for convinience
    lastCachedUrls = {}
    for c in cache
      lastCachedUrls[c.feedUrl] = c.latestPostUrl

    console.log "cache"
    console.log lastCachedUrls

    # collect new posts that were published after cached posts
    result = {}

    for feedUrl, posts of feedsAndPosts
      do (feedUrl, posts) ->
        lastPostUrl = lastCachedUrls[feedUrl]

        # here we process case when new subscription is added by user
        # and it's not yet in cache
        if lastPostUrl
          postsClone = posts.clone()
          newPosts = (post while (post = postsClone.shift()).link != lastPostUrl)

          result[feedUrl] = newPosts if newPosts.length > 0

    return result

  updateCache: (feedsAndPosts) ->
    cache = []
    for url, posts of feedsAndPosts
      cache.push { feedUrl: url, latestPostUrl: posts[0].link }

    @cacheRef.set cache, (error) =>
      if error
        console.log 'error happened while saving cache'
        process.exit(1)
      else
        @callback(@feedsWithNewPosts)
