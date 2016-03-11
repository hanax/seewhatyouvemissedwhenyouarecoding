GitHubApi = require 'github'
Firebase = require 'firebase'

arr = Array.apply(null, Array(364)).map () -> 0

github = new GitHubApi
  version: "3.0.0"
  debug: true
  protocol: "https"
  host: "api.github.com"
  timeout: 5000
  headers:
    "user-agent": 'test-App'

github.authenticate
  type: 'oauth'
  key: 'f71dff85b29f72cadeaf'
  secret: '762e2aa603eb2bdc3169a6db608ded9b102d4938'

handle = process.argv[2]

github.repos.getFromUser {user: handle}, (err, data) ->
  repos = data.map (e) -> e.name
  count = 0
  len = repos.length
  repos.forEach (rep) ->
    github.repos.getStatsCommitActivity {user: handle, repo: rep}, (err, data) ->
      throw Error err if err
      whole = data.reduce(((p, c) -> p.concat c.days), [])
      whole.forEach (e, i) ->
        arr[i] += e
      ++count
      if count is len
        ref = new Firebase "https://radiant-heat-702.firebaseio.com/#{handle}"
        ref.set arr
        console.log arr.reduce (p, c) -> p + c
