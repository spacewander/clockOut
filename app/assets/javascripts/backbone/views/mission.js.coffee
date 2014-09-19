class CurrentMissionView extends Backbone.View
  template: JST.currentMission
  el: '#current-missions'

  initialize: ->
    # do nothing

  events:
    'click .clock-out' : 'triggerClockOut'
    'click .abort' : 'triggerAbort'

  # currentMission here is currentMission Object
  addCurrentMission: (currentMission) ->
    @$el.append(@template(currentMission.attributes))
    @$el

  removeCurrentMission: (currentMission) ->
    $(".current-mission[data-id=#{currentMission.id}]").remove()
    @$el

  triggerClockOut: (event) ->
    $('.current-mission > .clock-out').each (idx, elem) ->
      if elem == event.currentTarget
        @clockOut($(elem).parent('.current-mission'))
        return

  triggerAbort: (event) ->
    $('.current-mission > .abort').each (idx, elem) ->
      if elem == event.currentTarget
        @abort($(elem).parent('.current-mission'))
        return

  # currentMission here is the html element which is the target mission
  abort: (currentMission) ->
    currentMission.addClass('aborted')

  clockOut: (currentMission) ->
    finishedDays = $(currentMission.children('.finished-days'))
    try
      now = Number(finishedDays.text()) + 1
      finishedDays.text(String(now))
    catch e
      # do nothing


