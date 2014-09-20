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
MissionLoader =
  init: ->
    page = document.getElementsByTagName('body')[0].className
    switch page
      when 'users-controller show-action'
        @bindNewMissionHandler()
        @bindShowFinishedMissionTrigger()
        @bindHideFinishedMissionTrigger()
        @fetchCurrentMissions()
        @fetchFinishedMissions()
      when 'mission-controller show-action'

      else
        # do nothing
    
  bindNewMissionHandler: ->
    $('#new-mission-btn').click (event) ->
      $('#new-mission-form').show()

  # 展示/隐藏已完成任务的方式，在访客模式和主人模式下都差不多，但是又有一些不同。
  # 比如主人模式下多了创建新任务的面板。所以这两个函数需要在不同的模式下重新定义
  bindShowFinishedMissionTrigger: ->

  bindHideFinishedMissionTrigger: ->

  fetchCurrentMissions: ->
    url = "/users/current_missions"
    $.get url, (data) ->
      if data.err
        console.log data.err
      else
        MissionLoader.initCurrentMissionModels(data.currentMissions)
    , 'json'
      .fail ->
        console.log 'fetch current missions fail!'

  fetchFinishedMissions: ->
    url = "/users/finished_missions"
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
  if $('.users-controller.index-action').length
    $('#user-index > tbody > tr').each (idx, elem) ->
      finished = $(elem).find('.finished-missions').text()
      created = $(elem).find('.created-missions').text()
      console.log finished
      $(elem).find('.progress-container').append(User.generalProgressBar(
        User.getPercentsFromMissions(finished, created)))

  MissionLoader.init()
