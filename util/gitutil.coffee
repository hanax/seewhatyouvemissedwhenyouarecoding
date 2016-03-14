# GitHubApi = require 'github'
Firebase = require 'firebase'
request = require 'request'
parseString = require('xml2js').parseString

# github = new GitHubApi
#   version: "3.0.0"
#   debug: true
#   protocol: "https"
#   host: "api.github.com"
#   timeout: 5000
#   headers:
#     "user-agent": 'test-App'

# github.authenticate
#   type: 'oauth'
#   key: 'f71dff85b29f72cadeaf'
#   secret: '762e2aa603eb2bdc3169a6db608ded9b102d4938'

handle = [
  'acsalu'
  'dblock'
  'GrahamCampbell'
  'Matt-Zhang'
  'Hacker-YHJ'
  'hanax'
  'haotianz'
  'HarrisonGregg'
  'hsiaoching'
  'infoxiao'
  'innainu'
  'jadami10'
  'kshreyas91'
  'liudan30'
  'mbostock'
  'MengjueW'
  'mmoorr'
  'Neo-DW'
  'nirg'
  'pangjac'
  'rishky'
  'sasinda'
  'sindhubr'
  'taylorotwell'
  'yeehanchan'
  'zaidhaque'
  'omris1'
  'copila'
  'praveen-g'
  'bc564'
  'bplaster'
  'hsiaoching'
  'xyilinu'
]
count = 0
sum = handle.length

handle.forEach (e) ->
  request "https://github.com/users/#{e}/contributions", (err, res, body) ->
    throw Error err if err
    console.log "scrape #{e} complete!"

    parseString body, (err, result) ->
      console.log "parse #{e} complete!"

      throw Error err if err
      gArr = result.svg.g[0].g
      gArr = gArr.map (gs) ->
        gs.rect.map (v) ->
          Number v.$['data-count']
      gArr = [].concat.apply [], gArr
      ref = new Firebase "https://radiant-heat-702.firebaseio.com/#{e}"
      ref.set gArr, () ->
        console.log "set #{e} complete! (#{++count}/#{sum})"
        console.log 'Now you can press ctrl-c to quit~' if count is sum

# github.repos.getFromUser {user: handle}, (err, data) ->
#   repos = data.map (e) -> e.name
#   count = 0
#   len = repos.length
#   repos.forEach (rep) ->
#     github.repos.getStatsCommitActivity {user: handle, repo: rep}, (err, data) ->
#       throw Error err if err
#       unless Array.isArray data
#         ++count
#         if count is len
#           ref = new Firebase "https://radiant-heat-702.firebaseio.com/#{handle}"
#           ref.set arr
#           console.log arr.reduce (p, c) -> p + c
#         return
#       whole = data.reduce(((p, c) -> p.concat c.days), [])
#       whole.forEach (e, i) ->
#         arr[i] += e
#       ++count
#       if count is len
#         ref = new Firebase "https://radiant-heat-702.firebaseio.com/#{handle}"
#         ref.set arr
#         console.log arr.reduce (p, c) -> p + c
