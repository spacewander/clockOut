# here define MissionLoader. MissionLoader is also defined in users.js.coffee,
# so only one of two can be use in a page

# this one used for visitors
MissionLoader =
  init: ->
    page = document.getElementsByTagName('body')[0].className
    switch page
      when 'users-controller show-action'
        # 通过解析url来获取用户ID，结果是String类型的
        @userId = window.location.pathname.split('/')[2]
        @fetchCurrentMissions()
        @fetchFinishedMissions()
      when 'mission-controller show-action'

      else
        # do nothing
    
  fetchCurrentMissions: ->
    url = "/users/#{@userId}/current_missions"
    $.get url, (data) =>
      if data.err
        console.log data.err
      else if data.currentMissions
        @__loadCurrentMissionView()
        @__initCurrentMissionModels(data.currentMissions)
      else
        console.log '加载当前任务失败'
    , 'json'
      .fail ->
        console.log 'fetch current missions fail!'

  fetchFinishedMissions: ->
    url = "/users/#{@userId}/finished_missions"
    $.get url, (data) =>
      if data.err
        console.log data.err
      else if data.finishedMissions
        @__loadFinishedMissionView()
        @__initFinishedMissionModels(data.finishedMissions)
      else
        console.log '加载已完成任务失败'
    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!'

  __loadFinishedMissionView: ->
    $('#finished-missions-panel').show()

  __loadCurrentMissionView: ->
    $('#current-missions-panel').show()

  __initCurrentMissionModels: (data) ->
    @view = new CurrentMissionView()
    @view.markAuthority('visitor')
    @collection = new CurrentMissionsCollection(@view)
    data.forEach (elem, idx) =>
      mission = new Mission(elem)
      @collection.add(elem)

  __initFinishedMissionModels: (data) ->
    @view = new FinishedMissionView()
    @view.markAuthority('visitor')
    @collection = new FinishedMissionCollection(@view)
    data.forEach (elem, idx) =>
      mission = new Mission(elem)
      @collection.add(elem)


$(document).ready ->
  MissionLoader.init()
