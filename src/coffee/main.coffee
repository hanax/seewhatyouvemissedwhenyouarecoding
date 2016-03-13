require '../stylus/main.styl'
Util = require './_util'

IMG_SIZE = 20
LOGGED_IN = false
CURRENT_MONTH = 0
MONTH_NAME = [
  'January', 'February', 'March',
  'April', 'May', 'June',
  'July', 'August', 'Sepetember',
  'October', 'November', 'December'
]

CAPTION_PREFIX = '''
WHAT<span style=\'color:#aaa\'>YOU</span>V<br/>
E<span style=\'color:#aaa\'>MISSED</span>W<br/>
HEN<span style=\'color:#aaa\'>YOU</span>AR<br/>E'''
CAPTION_SUFFIX = [
  'DEBUGGING.'
  'CODING.'
  'PROGRAMMING.'
  'WORKING.'
  'CHILLING.'
]
commits = []
photos = []
upperBoundYear = 0
upperBoundMonth = 0
lowerBoundYear = 0
lowerBoundMonth = 0

fetchImgFromLocal = (month, date, commits, cb) ->
  arr = Util.shuffle(photos[month][date])[0...commits]
  cb arr.map (e) ->
    {desc: e.desc, url: e.urls[e.urls.length-1], sUrl: e.urls[0]}

getImgByDate = (month, date, commits, location, cb) ->
  if photos[month]? and photos[month][date]?
    fetchImgFromLocal month, date, commits, cb
    return
  if commits is 0
    cb []
    return

  photoRef = new Firebase "https://radiant-heat-702.firebaseio.com/photos/#{month}-#{date}"

  photoRef.once 'value', (e) ->
    resArray = []
    val = e.val()
    for k, v of val
      resArray.push v
    photos[month] ||= []
    photos[month][date] = resArray || []

    # fake data if not available on flicr
    if photos[month][date].length is 0
      retArr = Util.arr commits, () ->
        str = "./assets/images/insta_data/img_#{~~(Math.random()*4)}.jpg"
        urls: [str, str]
        desc: 'This is ART!'
      photos[month][date] = retArr

    fetchImgFromLocal month, date, commits, cb

prepareUserData = (data) ->
  daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
  date = new Date()
  m = date.getMonth()
  y = date.getFullYear()
  d = date.getDate()
  upperBoundYear = y
  upperBoundMonth = m

  commits[y] ||= []
  commits[y][m] = data.slice(data.length-d).concat Util.arr(daysInMonth[m]-d)

  data = data[0...data.length-d]
  while data.length > 0
    if --m < 0 then --y and m = 11
    commits[y] ||= []
    if data.length >= daysInMonth[m]
      commits[y][m] = data.slice(data.length-daysInMonth[m])
      data = data[0...data.length-daysInMonth[m]]
    else
      commits[y][m] = Util.arr(daysInMonth[m] - data.length).concat data
      data = []

  lowerBoundYear = y
  lowerBoundMonth = m

getCommits = (month, year) ->
  commits[year][month]

startTypingAnimation = () ->
  setInterval(() ->
    $('#cursor').animate({opacity: 0}, 'fast').animate({opacity: 1}, 'fast')
  , 800)
  type(0, getRandomCaption())

getRandomCaption = () ->
  CAPTION_PREFIX + CAPTION_SUFFIX[~~(Math.random()*CAPTION_SUFFIX.length)]

type = (captionLength, caption) ->
  $('.caption').html(caption.substr(0, captionLength))
  nextChar = caption.charAt(++captionLength)
  while captionLength < caption.length && !(nextChar.match(/[A-Z.]/))
    nextChar = caption.charAt(++captionLength)
  setTimeout((if captionLength < caption.length + 1 then type else erase), 60, captionLength, caption)

erase = (captionLength, caption) ->
  $('.caption').html(caption.substr(0, captionLength--))
  if (captionLength > caption.indexOf('AR<br/>E') + 8)
    setTimeout(erase, 60, captionLength, caption)
  else
    setTimeout(type, 60, captionLength, getRandomCaption())

$ () ->
  startTypingAnimation()
  $('.img-fullscreen').on('click', () -> $('.img-fullscreen').fadeOut('fast'))

  # Default: current month
  displayMonth = new Date().getMonth()
  displayYear = new Date().getFullYear()

  $('#prev').on('click', () ->
    if displayMonth is 0
      displayMonth = 11
      displayYear -= 1
    else
      displayMonth -= 1
    refreshUIByMonth(displayMonth, displayYear))

  $('#next').on('click', () ->
    if displayMonth is 11
      displayMonth = 0
      displayYear += 1
    else
      displayMonth += 1
    refreshUIByMonth(displayMonth, displayYear))

  ref = new Firebase 'https://radiant-heat-702.firebaseio.com'
  $('.btn-login').on 'click', () ->
    ref.authWithOAuthPopup 'github', (error, authData) ->
      if error
        alert "Login Failed!", error
      else
        # console.log authData
        dataRef = new Firebase "https://radiant-heat-702.firebaseio.com/#{authData.github.username}"
        dataRef.once 'value', (e) ->
          prepareUserData(e.val())
          $('.view-login').fadeOut('fast')
          refreshUIByMonth(displayMonth, displayYear)

refreshUIByMonth = (curMonth, curYear) ->
  $('#prev').css 'visibility', 'visible'
  $('#next').css 'visibility', 'visible'
  if curMonth is upperBoundMonth and curYear is upperBoundYear
    $('#next').css 'visibility', 'hidden'
  else if curMonth is lowerBoundMonth and curYear is lowerBoundYear
    $('#prev').css 'visibility', 'hidden'

  $('.insta-img').remove()
  $('.date-label').remove()

  commitsInDay = getCommits(curMonth, curYear)
  daysInCurMonth = commitsInDay.length
  xLen = parseInt($('.main-insta-view').css('width'))
  yLen = parseInt($('.main-insta-view').css('height'))
  xItv = xLen / daysInCurMonth
  yItv = 5
  maxImgPerDay = ~~(yLen / (IMG_SIZE + yItv))

  [0...daysInCurMonth].forEach (i) ->
    getImgByDate curMonth, i+1, commitsInDay[i], 'NY', (imgForToday) ->
      for j in [0...Math.min(commitsInDay[i], maxImgPerDay)]
        $ '<div />',
          class: 'insta-img',
          mouseover: (e) ->
            return if ($('.bg-insta-info').css('backgroundImage') is $(e.target).data 'bgExUrl')

            $('.bg-insta-info').fadeOut 100, () ->
              $('.bg-insta-info').css('backgroundImage', $(e.target).data 'bgExUrl' )
              $('.bg-insta-info').fadeIn(100)
          click: (e) ->
            $('.img-fullscreen img')
              .attr('src', $(e.target).data('bgUrl'))
            $('.img-fullscreen p')
              .text($(e.target).data('desc'))
            $('.img-fullscreen').fadeIn('fast')
        .css
          bottom: j * (IMG_SIZE + yItv)
          left: i * xItv
          backgroundImage: "url('#{imgForToday[j].sUrl}')"
        .data 'desc', imgForToday[j].desc
        .data 'bgUrl', imgForToday[j].url
        .data 'bgExUrl', "url('#{imgForToday[j].url}')"
        .attr 'alt', imgForToday[j].desc
        .appendTo $('.main-insta-view')

  for i in [0...daysInCurMonth]
    $ '<div />',
      class: 'date-label'
      text: i + 1
    .css
      'top': 0
      'left': i * xItv
    .appendTo $('.axis-info')

  $('.month-label').text "#{MONTH_NAME[curMonth]}, #{curYear}"
