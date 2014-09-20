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
    $('.current-mission > .clock-out').each (idx, elem) =>
      if elem == event.currentTarget
        @clockOut($(elem).parent('.current-mission'))
        return

  triggerAbort: (event) ->
    $('.current-mission > .abort').each (idx, elem) =>
      if elem == event.currentTarget
        @abort($(elem).parent())
        return

  # currentMission here is the html element which is the target mission
  # 在触发服务器端之前，先修改客户端的数据。
  # 即使客户端的数据修改失败，依然会从服务器端获取最新的数据获取最新的数据
  abort: (currentMission) ->
    currentMission.addClass('aborted')

  clockOut: (currentMission) ->
    finishedDays = $(currentMission.children('.finished-days'))
    try
      now = Number(finishedDays.text()) + 1
      finishedDays.text(String(now))
    catch e
      # do nothing
    try
      $(currentMission.find('.drop-out-days')).text('0')
    catch e
      # do nothing


