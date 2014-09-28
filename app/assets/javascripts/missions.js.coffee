# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.CommonMissionLoader =
  loadFinishedMissionView: (authority = 'visitor') ->
    @finishedView = new FinishedMissionView()
    @finishedView.markAuthority(authority)
    @finishedMissions = new FinishedMissionCollection(@finishedView)

  hideFinishedMissionView: ->
    $('#finished-missions-panel').hide()

  loadCurrentMissionView: (authority = 'visitor') ->
    @currentView = new CurrentMissionView()
    @currentView.markAuthority(authority)
    @currentMissions = new CurrentMissionsCollection(@currentView)

  hideCurrentMissionView: ->
    $('#current-missions-panel').hide()

  initCurrentMissionModels: (data) ->
    @currentMissions.reset()
    data.forEach (elem, idx) =>
      mission = new Mission(elem)
      @currentMissions.add(elem)

  initFinishedMissionModels: (data) ->
    @finishedMissions.reset()
    data.forEach (elem, idx) =>
      mission = new Mission(elem)
      @finishedMissions.add(elem)


UserShowAction =
  togglePanels: (hideCurrent)->
    $('#current-missions-panel')?.slideToggle 'fast', () ->
      $('#new-mission-panel')?.slideToggle 'fast', () ->
        $('#finished-missions-table').toggle()

  preventReload: ->
    $('#navbar-name > a').css('cursor', 'default')
    $('#navbar-name > a').click (event) ->
      if $(this).attr('href') == window.location.pathname
        event.preventDefault()

  recoverPanels: (isCurrentMissionsHidden, isFinishedMissionsHidden) ->
    if isCurrentMissionsHidden
      $('#current-missions-panel').hide()
    else
      $('#current-missions-panel').show()
    if isFinishedMissionsHidden
      $('#finished-missions-panel').hide()
    else
      $('#finished-missions-panel').show()
      
      

$(document).ready ->
  if $('.users-controller.show-action').length
    UserShowAction.preventReload()

    isCurrentMissionsHidden = $('#current-missions-panel:hidden').length
    isFinishedMissionsHidden = $('#finished-missions-panel:hidden').length
    $('#finished-missions-panel > .drop').click (event) ->
      if $(this).hasClass('dropup')
        UserShowAction.togglePanels()

        $(this).children('.show-finished-missions').text('显示当前的任务')
        $(this).children('.caret').toggleClass('up down')
        $(this).toggleClass('dropup dropdown')
      else
        UserShowAction.togglePanels()

        $(this).children('.show-finished-missions').text('显示已完成的任务')
        $(this).children('.caret').toggleClass('up down')
        $(this).toggleClass('dropup dropdown')

      UserShowAction.recoverPanels(isCurrentMissionsHidden,
                                    isFinishedMissionsHidden)

