# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Sessions =
  init: ->
    #  trigger modal
    $('#login-modal').modal()
    $('#login-modal').on 'hidden.bs.modal', (e) ->
      $('#panel').text("刷新再来过吧。")
      $('#panel').css({
        'font-size': '40px',
        'text-align' : 'center'
      })
      
    @bindUsernameChecker()
    @bindPasswordChecker()

  # 每次'#notice'改动后触发该函数
  hideErrorWhenNoticeGiven: ->
    if $('#error').length
      $('#error').hide()

  bindUsernameChecker: ->
    $('.login-form > form').submit (event) ->
      text = $("input[name=name]").val()
      if text == ''
        event.preventDefault()
        Sessions.hideErrorWhenNoticeGiven()
        $('#notice').text('用户名不能为空')
        $('input[name=name]').val('')

  bindPasswordChecker: ->
    $('.login-form > form').submit (event) ->
      text = $("input[name=password]").val()
      if text == ''
        event.preventDefault()
        Sessions.hideErrorWhenNoticeGiven()
        $('#notice').text('密码不能为空')
        $('input[name=password]').val('')


$(document).ready ->
  Sessions.init()
