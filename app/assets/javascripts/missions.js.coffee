# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
UserShowAction =
  togglePanels: ->
    $('#current-missions-panel')?.slideToggle 'fast', () ->
      $('#new-mission-panel')?.slideToggle 'fast', () ->
        $('#finished-missions-table').toggle()

  preventReload: ->
    $('#navbar-name > a').click (event) ->
      if $(this).attr('href') == window.location.pathname
        event.preventDefault()

$(document).ready ->
  if $('.users-controller.show-action').length
    UserShowAction.preventReload()

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

