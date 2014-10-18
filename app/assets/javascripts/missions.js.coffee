MissionShowAction =
  makeContentEditable: ->
    $('#mission-content-panel').hover (event) ->
      $('#mission-content').hide()
      $('#mission-editor').show()
    , (event) ->
      $('#mission-content').show()
      $('#mission-editor').hide()

  updateMission: ->
    $('#update-mission').click () ->
      console.log $('#mission-editor > textarea').val()
      $.ajax
        url: "/missions/#{window.location.pathname.split('/')[2]}.json",
        type: 'PUT',
        data:
          'content': $('#mission-editor > textarea').val().trim()
          'mission': {
            'user_id': $('#user_id').val()
            'user_token': $('#user_token').val()
          }
        success: (res) ->
          if res.id
            $('#mission-content').text($('#mission-editor').val())
            $('#mission-editor').hide()
            $('#mission-content').show()
      

$(document).ready ->
  if $('.missions-controller.show-action').length
    MissionShowAction.makeContentEditable()
    MissionShowAction.updateMission()
