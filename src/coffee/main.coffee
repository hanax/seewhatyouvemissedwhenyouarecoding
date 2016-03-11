require '../stylus/main.styl'

getImgByDate = (month, date, commits, location) ->
  ('./assets/images/insta_data/img_' + ~~(Math.random()*4) + '.jpg' for i in [0...commits])

getCommitsByMonth = (month) ->
  [
    20, 2, 0, 0, 0,
    2, 3, 0, 0, 0,
    12, 10, 11, 12, 8,
    10, 23, 2, 7, 2,
    3, 5, 11, 12, 30,
    8, 9, 11, 12, 13
  ]

IMG_SIZE = 20
CUR_YEAR = 2016

MONTH_NAME = [
  'January', 'February', 'March', 
  'April', 'May', 'June', 
  'July', 'August', 'Sepetember', 
  'October', 'November', 'December'
]

$(() ->
  displayMonth = new Date().getMonth()+1
  refreshUIByMonth(displayMonth)

  $('#prev').on('click', () ->
    displayMonth -= 1
    if (displayMonth < 0)
      displayMonth = 11
      CUR_YEAR -= 1
    refreshUIByMonth(displayMonth))

  $('#next').on('click', () ->
    displayMonth += 1
    if (displayMonth >= 12)
      displayMonth = 0
      CUR_YEAR += 1
    refreshUIByMonth(displayMonth))
)

refreshUIByMonth = (curMonth) ->
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
        })
        .css({
          'bottom': j * (IMG_SIZE + yItv),
          'left': i * xItv,
          'backgroundImage': 'url(\'' + imgForToday[j] + '\')'
        })
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

  $('.month-label').text(MONTH_NAME[curMonth] + ', ' + CUR_YEAR)
