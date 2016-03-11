domready = require 'domready'

domready ->
  ref = new Firebase 'https://radiant-heat-702.firebaseio.com'
  window.test =  () ->
    ref.authWithOAuthPopup 'github', (error, authData) ->
      if error
        console.log "Login Failed!", error
      else
        console.log "Authenticated successfully with payload:", authData
