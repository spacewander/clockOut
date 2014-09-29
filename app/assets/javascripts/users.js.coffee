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
        CommonMissionLoader.loadFinishedMissionView(@authority)
        CommonMissionLoader.loadCurrentMissionView(@authority)
        @fetchCurrentMissions()
        @fetchFinishedMissions()
      when 'mission-controller show-action'

      else
        # do nothing
    
  bindNewMissionHandler: ->
    $('#new-mission-btn').click (event) ->
      $('#new-mission-form').show()

  fetchCurrentMissions: ->
    url = "/users/current_missions"
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
      url = "/users/finished_missions"
    else
      url = "/users/finished_missions?page=#{page}"

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


$(document).ready ->
  if $('.users-controller.index-action').length
    $('#user-index > tbody > tr').each (idx, elem) ->
      finished = $(elem).find('.finished-missions').text()
      created = $(elem).find('.created-missions').text()
      console.log finished
      $(elem).find('.progress-container').append(User.generalProgressBar(
        User.getPercentsFromMissions(finished, created)))

