# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# here define MissionLoader. MissionLoader is also defined in others.js.coffee,
# so only one of two can be use in a page

# this one used for hoster
window.MissionLoader =
  init: ()->
    page = document.getElementsByTagName('body')[0].className
    switch page
      when 'users-controller show-action'
        @authority = 'hoster'
        @bindNewMissionHandler()
      when 'mission-controller show-action'

      else
        # do nothing
    
  bindNewMissionHandler: ->
    $('#new-mission-btn').click (event) ->
      $('#new-mission-form').show()

  fetchCurrentMissions: ->
    url = "/users/current_missions"
    $.get url, (data) =>
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
      url = "/users/finished_missions"
    else
      url = "/users/finished_missions?page=#{page}"

    $.get url, (data) =>
      if data.finishedMissions
        CommonMissionLoader.loadFinishedMissionView(@authority)
        currentPageNum = Number($('li.active > a').text())
        currentPageNum = 1 if !currentPageNum
        CommonMissionLoader.updatePaginationBar(
          data.pageNum,
          currentPageNum
        )
        CommonMissionLoader.initFinishedMissionModels(data.finishedMissions)

        CommonMissionLoader.changeRouteHash(page)
        return
      else if data.err
        console.log data.err
      else
        console.log data

    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!' # 该输出用于检查是否去抓取对应数据


$(document).ready ->
  if $('.users-controller.show-action').length
    # 覆盖掉bootstrap警告框默认的关闭方法，现在不会把整个警告框DOM移除了，只是隐藏了起来
    $('button.close').unbind('click').click (event) ->
      $('#alert-bar').fadeOut()
      event.stopImmediatePropagation()

