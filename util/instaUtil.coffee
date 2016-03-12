ig = require('instagram-node').instagram()

ig.use
  access_token: '1606893087.c8eac2a.424c9abd4e604e6cbb60adc411cda574'
  client_id: 'c8eac2a60ea34df38af02236f203457b'
  client_secret: '059203c75bff49219e9275922326d3a7'

ig.media_search 40.7127, -74.0059, (err, medias, remaining, limit) ->
  throw Error err if err
  console.log medias
  console.log remaining
