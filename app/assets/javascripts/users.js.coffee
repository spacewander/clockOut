# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

User =
  # @param percents : the percents(number like '20') of progressbar
  # @return a string which should be inserted
  generalProgressBar: (percents) ->
    unless 0 <= percents <= 100
      return ''
    return User.progressbarDetail(percents)

  progressbarDetail: (percents) ->
    return """
  <div class="progress">
    <div class="progress-bar progress-bar-success" role="progressbar"
      aria-valuenow="#{percents}" aria-valuemin="0" aria-valuemax="100"
      style="width: #{percents}%">
      <span class="sr-only">#{percents}%</span>
    </div>
  </div>
    """

  # @param finished : text of current row's $(".finished-missions")
  # @param created : text of current row's $(".created-missions")
  getPercentsFromMissions: (finished, created) ->
    if created == '0'
      return 0
    else
      try
        finished = Number(finished)
        created = Number(created)
        if finished <= created
          return finished * 100 / created
        else
          throw new Error('完成的任务数不能超过创建的任务数')
      catch e
        #console.log e.message
        return 0


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

        CommonMissionLoader.changeRouteHash()
        return
      else if data.err
        console.log data.err
      else
        console.log data

    , 'json'
      .fail ->
        console.log 'fetch finished missions fail!' # 该输出用于检查是否去抓取对应数据


$(document).ready ->
  if $('.users-controller.index-action').length
    $('#user-index > tbody > tr').each (idx, elem) ->
      finished = $(elem).find('.finished-missions').text()
      created = $(elem).find('.created-missions').text()
      $(elem).find('.progress-container').append(User.generalProgressBar(
        User.getPercentsFromMissions(finished, created)))
  else if $('.users-controller.show-action').length
    # 覆盖掉bootstrap警告框默认的关闭方法，现在不会把整个警告框DOM移除了，只是隐藏了起来
    $('button.close').unbind('click').click (event) ->
      $('#alert-bar').fadeOut()
      event.stopImmediatePropagation()

