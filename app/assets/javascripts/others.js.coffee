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
      when 'mission-controller show-action'

      else
        # do nothing
    
  fetchCurrentMissions: ->
    url = "/users/#{@userId}/current_missions"
    $.get url, (data) ->
      if data.currentMissions
        CommonMissionLoader.loadCurrentMissionView(@authority)
        CommonMissionLoader.initCurrentMissionModels(data.currentMissions)
        return
      else if data.err
        console.log data.err
      else
        console.log data

    , 'json'
      .fail ->
        console.log 'fetch current missions fail!'

  fetchFinishedMissions: (page = 1) ->
    if page == 1
      url = "/users/#{@userId}/finished_missions"
    else
      url = "/users/#{@userId}/finished_missions?page=#{page}"

    $.get url, (data) ->
      if data.finishedMissions
        CommonMissionLoader.loadFinishedMissionView(@authority)
        currentPageNum = Number($('li.active > a').text())
        currentPageNum = 1 if !currentPageNum
        CommonMissionLoader.updatePaginationBar(
          data.pageNum,
          currentPageNum
        )
        CommonMissionLoader.initFinishedMissionModels(data.finishedMissions)

        CommonMissionLoader.changeRouteHash()
        return
      else if data.err
        console.log data.err
      else
        console.log data

    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!' # 该输出用于检查是否去抓取对应数据

