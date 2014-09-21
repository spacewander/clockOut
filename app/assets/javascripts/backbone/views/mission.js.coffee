class window.CurrentMissionView extends Backbone.View
  template: JST.currentMission
  el: '#current-missions'

  initialize: ->
    # do nothing

  events:
    'click .clock-out' : 'triggerClockOut'
    'click .abort' : 'triggerAbort'

  # 设置视图权限，不同用户使用的模板有些许不同
  # 在初始化之后被外界调用
  markAuthority: (role) ->
    switch role
      when 'hoster'
        @role = 'hoster'
      when 'visitor'
        @role = 'visitor'
      else

    
  # currentMission here is currentMission Object
  addCurrentMission: (currentMission) ->
    attributes = currentMission.attributes
    attributes.role = @role
    @$el.append(@template(attributes))
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
    if confirm('你真的打算放弃这项任务吗？是否承认失败？')
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


class window.FinishedMissionView extends Backbone.View
  template: JST.finishedMission
  el: '#finished-missions'

  # 设置视图权限，不同用户使用的模板有些许不同
  # 在初始化之后被外界调用
  markAuthority: (role) ->
    switch role
      when 'hoster'
        @role = 'hoster'
      when 'visitor'
        @role = 'visitor'
      else

  addFinishedMission: (finishedMission) ->
    attributes = finishedMission.attributes
    attributes.role = @role
    @$el.append(@template(attributes))
    @$el

  removeCurrentMission: (finishedMission) ->
    $(".finished-mission[data-id=#{finishedMission.id}]").remove()
    @$el

