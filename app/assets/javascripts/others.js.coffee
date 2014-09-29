# here define MissionLoader. MissionLoader is also defined in users.js.coffee,
# so only one of two can be use in a page

# this one used for visitors
window.MissionLoader =
  init: ()->
    page = document.getElementsByTagName('body')[0].className
    switch page
      when 'users-controller show-action'
        # 通过解析url来获取用户ID，结果是String类型的
        @userId = window.location.pathname.split('/')[2]
        @authority = 'visitor'
        CommonMissionLoader.loadCurrentMissionView(@authority)
        CommonMissionLoader.loadFinishedMissionView(@authority)
        @fetchCurrentMissions()
        @fetchFinishedMissions()
      when 'mission-controller show-action'

      else
        # do nothing
    
  fetchCurrentMissions: ->
    url = "/users/#{@userId}/current_missions"
    $.get url, (data) ->
      if data.currentMissions
        CommonMissionLoader.initCurrentMissionModels(data.currentMissions)
        return
      else if data.err
        console.log data.err
      else
        console.log data

      CommonMissionLoader.hideCurrentMissionView()
    , 'json'
      .fail ->
        console.log 'fetch current missions fail!'
        CommonMissionLoader.hideCurrentMissionView()

  fetchFinishedMissions: (page = 1) ->
    if page == 1
      url = "/users/#{@userId}/finished_missions"
    else
      url = "/users/#{@userId}/finished_missions?page=#{page}"

    $.get url, (data) ->
      if data.finishedMissions
        currentPageNum = Number($('li.active > a').text())
        currentPageNum = 1 if !currentPageNum
        CommonMissionLoader.updatePaginationBar(
          data.pageNum,
          currentPageNum
        )
        CommonMissionLoader.initFinishedMissionModels(data.finishedMissions)
        return
      else if data.err
        console.log data.err
      else
        console.log data

      CommonMissionLoader.hideFinishedMissionView()
    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!'
        CommonMissionLoader.hideFinishedMissionView()

