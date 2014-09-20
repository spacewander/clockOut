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
        @bindShowFinishedMissionTrigger()
        @bindHideFinishedMissionTrigger()
        @fetchCurrentMissions()
        @fetchFinishedMissions()
      when 'mission-controller show-action'

      else
        # do nothing
    
  bindShowFinishedMissionTrigger: ->

  bindHideFinishedMissionTrigger: ->

  fetchCurrentMissions: ->
    url = "/users/#{@userId}/current_missions"
    $.get url, (data) ->
      if data.err
        console.log data.err
      else
        MissionLoader.initCurrentMissionModels(data.currentMissions)
    , 'json'
      .fail ->
        console.log 'fetch current missions fail!'

  fetchFinishedMissions: ->
    url = "/users/#{@userId}/finished_missions"
    $.get url, (data) ->
      if data.err
        console.log data.err
      else
        MissionLoader.initFinishedMissionModels(data.finishedMissions)
    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!'

  initCurrentMissionModels: (data) ->
    view = new CurrentMissionView()
    collection = new CurrentMissionsCollection(view)
    data.forEach (elem, idx) ->
      mission = new Mission(elem)
      collection.add(elem)

  initFinishedMissionModels: (data) ->
    view = new FinishedMissionView()
    collection = new FinishedMissionCollection(view)
    data.forEach (elem, idx) ->
      mission = new Mission(elem)
      collection.add(elem)


$(document).ready ->
  MissionLoader.init()
