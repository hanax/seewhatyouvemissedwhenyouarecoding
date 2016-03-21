require '../stylus/main.styl'
Util = require './_util'

FIREBASE_URL = 'https://radiant-heat-702.firebaseio.com/'
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

fetchImgFromLocal = (year, month, date, commits, cb) ->
  arr = Util.shuffle(photos[year][month][date])[0...commits]
  cb arr.map (e) ->
    {desc: e.desc, url: e.urls[e.urls.length-1], sUrl: e.urls[0]}

getImgByDate = (year, month, date, commits, location, cb) ->
  if commits is 0
    cb []
    return

  if photos[year]? and photos[year][month]? and photos[year][month][date]?
    fetchImgFromLocal year, month, date, commits, cb
    return

  $.post
    url: '/api/wyvmwyac/firebase'
    data:
      year: year
      month: month
      date: date
    dataType: 'json'
    success: (e) ->
      photos[year] ||= []
      photos[year][month] || =[]
      photos[year][month][date] = e || []
      fetchImgFromLocal year, month, date, commits, cb

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
  type 0, getRandomCaption()

getRandomCaption = () ->
  CAPTION_PREFIX + CAPTION_SUFFIX[~~(Math.random()*CAPTION_SUFFIX.length)]

type = (captionLength, caption) ->
  $('.caption').html caption.substr(0, captionLength)
  nextChar = caption.charAt ++captionLength
  while captionLength < caption.length && !(nextChar.match(/[A-Z.]/))
    nextChar = caption.charAt ++captionLength
  setTimeout (if captionLength < caption.length + 1 then type else erase),
    60,
    captionLength,
    caption

erase = (captionLength, caption) ->
  $('.caption').html caption.substr(0, captionLength--)
  if  captionLength > caption.indexOf('AR<br/>E') + 8
    setTimeout erase, 60, captionLength, caption
  else
    setTimeout type, 60, captionLength, getRandomCaption()

$ () ->
  startTypingAnimation()
  $('.img-fullscreen').on 'click', () -> $('.img-fullscreen').fadeOut 'fast'

  # Default: current month
  displayMonth = new Date().getMonth()
  displayYear = new Date().getFullYear()

  $('#prev').on 'click', () ->
    if displayMonth is 0
      displayMonth = 11
      displayYear -= 1
    else
      displayMonth -= 1
    refreshUIByMonth displayMonth, displayYear

  $('#next').on 'click', () ->
    if displayMonth is 11
      displayMonth = 0
      displayYear += 1
    else
      displayMonth += 1
    refreshUIByMonth displayMonth, displayYear

  ref = new Firebase FIREBASE_URL
  $('.btn-login').on 'click', () ->
    ref.authWithOAuthPopup 'github', (error, authData) ->
      if error
        alert "Login Failed!", error
      else
        # avatar
        # authData.github.profileImageURL

        # HERE: replace firebase with custom server
        # dataRef = new Firebase "#{FIREBASE_URL}#{authData.github.username}"
        # dataRef.once 'value', (e) ->
        #   prepareUserData e.val()
        #   $('.view-login').fadeOut 'fast'
        #   refreshUIByMonth displayMonth, displayYear

        $.post
          url: '/api/wyvmwyac/github'
          data: {handle: authData.github.username}
          dataType: 'json'
          success: (e) ->
            prepareUserData e
            $('.view-login').fadeOut 'fast'
            refreshUIByMonth displayMonth, displayYear


refreshUIByMonth = (curMonth, curYear) ->
  $('#prev').css 'visibility', 'visible'
  $('#next').css 'visibility', 'visible'
  if curMonth is upperBoundMonth and curYear is upperBoundYear
    $('#next').css 'visibility', 'hidden'
  else if curMonth is lowerBoundMonth and curYear is lowerBoundYear
    $('#prev').css 'visibility', 'hidden'

  $('.insta-img').remove()
  $('.date-label').remove()

  commitsInDay = getCommits curMonth, curYear
  daysInCurMonth = commitsInDay.length
  xLen = parseInt $('.main-insta-view').css('width')
  yLen = parseInt $('.main-insta-view').css('height')
  xItv = xLen / daysInCurMonth
  yItv = 5
  maxImgPerDay = ~~(yLen / (IMG_SIZE + yItv))

  [0...daysInCurMonth].forEach (i) ->
    getImgByDate curYear, curMonth, i+1, commitsInDay[i], 'NY', (imgForToday) ->
      [0...Math.min(commitsInDay[i], maxImgPerDay)].forEach (j) ->
        keywords = imgForToday[j].desc.split(" ")
        if keywords.length is 1
          keywords = imgForToday[j].desc.split("#")
        $ '<div />',
          class: 'insta-img',
          mouseover: (e) ->
            return if  $('.bg-insta-info').css('backgroundImage') is
              $(e.target).data('bgExUrl')

            $('.bg-insta-info').fadeOut 100, () ->
              $('.bg-insta-info').css 'backgroundImage',
                $(e.target).data( 'bgExUrl')
              $('.bg-insta-info').fadeIn 100

            for k,i in keywords
              $ '<div />',
                class: 'desc-subtitle'
                id: i
                text: k
              .css
                'top': Math.random() * $(window).height()
                'left': Math.random() * $(window).width() - 100
                'fontSize': Math.max(40, Math.random() * 100) + 'px'
                'opacity': Math.max(0.2, Math.random())
              .appendTo $('body')
          mouseout: () ->
            $('.desc-subtitle').remove()
          click: (e) ->
            $('.img-fullscreen img')
              .attr 'src', $(e.target).data('bgUrl')
            $('.img-fullscreen p')
              .text $(e.target).data('desc')
            $('.img-fullscreen').fadeIn 'fast'
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
