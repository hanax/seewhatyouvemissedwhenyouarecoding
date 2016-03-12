require '../stylus/main.styl'

IMG_SIZE = 20

LOGGED_IN = false

MONTH_NAME = [
  'January', 'February', 'March', 
  'April', 'May', 'June', 
  'July', 'August', 'Sepetember', 
  'October', 'November', 'December'
]

getImgByDate = (month, date, commits, location) ->
  retArr = []
  for i in [0...commits]
    retArr.push(
      url: './assets/images/insta_data/img_' + ~~(Math.random() * 4) + '.jpg'
      desc: 'blabla'
    )
  return retArr

getCommitsByMonth = (month) ->
  [
    20, 2, 0, 0, 0,
    2, 3, 0, 0, 0,
    12, 10, 11, 12, 8,
    10, 23, 2, 7, 2,
    3, 5, 11, 12, 30,
    8, 9, 11, 12, 13
  ]

$(() ->
  $('.img-fullscreen').on('click', () -> $('.img-fullscreen').fadeOut('fast'))

  $('#prev').on('click', () ->
    if displayMonth <= 1
      displayMonth = 11
      displayYear -= 1
    else
      displayMonth -= 1
    refreshUIByMonth(displayMonth, displayYear))

  $('#next').on('click', () ->
    if displayMonth >= 11
      displayMonth = 0
      displayYear += 1
    else
      displayMonth += 1
    refreshUIByMonth(displayMonth, displayYear))

  if !LOGGED_IN 
    $('.view-login').show()
  else
    $('.view-login').hide()
    displayMonth = new Date().getMonth()+1
    displayYear = 2016
    refreshUIByMonth(displayMonth, displayYear)

)

refreshUIByMonth = (curMonth, curYear) ->
  commitsInDay = getCommitsByMonth(curMonth)
  daysInCurMonth = commitsInDay.length
  xLen = parseInt($('.main-insta-view').css('width'))
  yLen = parseInt($('.main-insta-view').css('height'))
  xItv = xLen / daysInCurMonth
  yItv = 5
  maxImgPerDay = ~~(yLen / (IMG_SIZE + yItv)) ;

  for i in [0...daysInCurMonth]
    imgForToday = getImgByDate(curMonth, i, commitsInDay[i])
    for j in [0...Math.min(commitsInDay[i], maxImgPerDay)]
      $('<div />', {
          'class': 'insta-img',
          mouseover: (e) -> 
            if ($('.bg-insta-info').css('backgroundImage') != $(e.target).css('backgroundImage'))
              $('.bg-insta-info').fadeOut(100, () ->
                $('.bg-insta-info').css('backgroundImage', $(e.target).css('backgroundImage'))
                $('.bg-insta-info').fadeIn(100))
          ,
          click: (e) ->
            $('.img-fullscreen img')
              .attr('src', $(e.target).css('backgroundImage').replace('url(\"', '').replace('\")', ''))
            $('.img-fullscreen p')
              .text($(e.target).data('desc'))
            $('.img-fullscreen').fadeIn('fast')
        })
        .css({
          'bottom': j * (IMG_SIZE + yItv),
          'left': i * xItv,
          'backgroundImage': 'url(\'' + imgForToday[j].url + '\')'
        })
        .data('desc', imgForToday[j].desc)
        .attr('alt', imgForToday[j].desc)
        .appendTo($('.main-insta-view'))

  for i in [0...daysInCurMonth]
    $('<div />', {
        'class': 'date-label',
        text: i + 1
      })
      .css({
        'top': 0,
        'left': i * xItv,
      })
      .appendTo($('.axis-info'))

  $('.month-label').text(MONTH_NAME[curMonth] + ', ' + curYear)
