require '../stylus/main.styl'

getImgByDate = (month, date, commits, location) ->
  ('./assets/images/insta_data/img_' + ~~(Math.random()*3) + '.jpg' for i in [0...commits])

getCommitsByMonth = (month) ->
  [
    20, 2, 0, 0, 0,
    2, 3, 0, 0, 0,
    12, 10, 11, 12,
    10, 23, 2, 7, 2,
    3, 5, 11, 12, 30,
    8, 9, 11, 12, 13
  ]

$(() ->
  commitsInDay = getCommitsByMonth()
  daysInCurMonth = commitsInDay.length
  imgSize = 20;
  xLen = parseInt($('.main-insta-view').css('width'))
  yLen = parseInt($('.main-insta-view').css('height'))
  xItv = xLen / daysInCurMonth
  yItv = 5
  maxImgPerDay = ~~(yLen / (imgSize + yItv)) ;

  curMonth = 3

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
          'bottom': j*(imgSize+yItv),
          'left': i*xItv,
          'backgroundImage': 'url(\'' + imgForToday[j] + '\')'
        })
        .appendTo($('.main-insta-view'));
)
