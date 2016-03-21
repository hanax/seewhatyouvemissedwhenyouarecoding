Flickr = require 'flickrapi'
Firebase = require 'firebase'

option =
  api_key: '7706a7c56a39a074d581c3b69581d2fa'
  secret: '8f8cd52dd2e45ebc'

count = 1

Flickr.tokenOnly option, (error, flickr) ->
  throw Error error if error
  searchAndStore new Date(2016,2,15), flickr


searchAndStore = (date, flickr) ->
  startD = new Date(date)
  console.log "searching... #{startD.toString()}"

  m = startD.getMonth()
  d = startD.getDate()
  startD.setHours(0,0,0,0)
  endD = new Date(date)
  endD.setHours(23,59,59,999)

  searchOptions =
    bbox: '-74.2589,40.4774,-73.7004,40.9176'
    min_upload_date: ~~(+startD/1000)
    max_upload_date: ~~(+endD/1000)

  flickr.photos.search searchOptions, (err, data) ->
    throw Error err if err
    photos = data.photos.photo
    photoCount = if photos.length < 50 then photos.length else 50
    photos[0...50].forEach (p) ->
      flickr.photos.getSizes {photo_id: p.id}, (errr, data) ->
        if errr
          console.log errr
          if --photoCount is 0
            if --count > 0
              searchAndStore date - 1000*60*60*24, flickr
          return

        arr = data.sizes.size
        ref = new Firebase "https://radiant-heat-702.firebaseio.com/photos/#{m}-#{d}"
        ref.push
          desc: p.title
          urls: arr.map (e) -> e.source
        if --photoCount is 0
          if --count > 0
            searchAndStore date - 1000*60*60*24, flickr
