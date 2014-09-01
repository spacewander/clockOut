# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
FormHelper =
  init: ->
    where = document.getElementsByTagName('body')[0].className.split(" ")
    return unless where?
    if "sessions-controller" in where
      @triggerModal()
      @bindUsernameChecker()
      @bindPasswordChecker()
    else if 'users-controller' in where
      @bindUsernameRegisterChecker()
      @bindPasswordRegisterChecker()
      @bindEmailReigisterChecker()
      @bindDateReigisterChecker()

  # 每次'#notice'改动后触发该函数，用于登录表单
  hideErrorWhenNoticeGiven: ->
    if $('#error').length
      $('#error').hide()

  bindUsernameChecker: ->
    $('.login-form > form').submit (event) ->
      text = $("input[name=name]").val().trim()
      if text == ''
        event.preventDefault()
        FormHelper.hideErrorWhenNoticeGiven()
        $('#notice').text('用户名不能为空')
        $('input[name=name]').val('')

  bindPasswordChecker: ->
    $('.login-form > form').submit (event) ->
      text = $("input[name=password]").val().trim()
      if text == ''
        event.preventDefault()
        FormHelper.hideErrorWhenNoticeGiven()
        $('#notice').text('密码不能为空')
        $('input[name=password]').val('')

  # 根据标签名来给同级的help-block添加信息。注意新的信息会覆盖掉旧信息
  editHelpBlock: (labelName, msg) ->
    return if labelName == ''
    console.log $('label[for=' + labelName + '] ~ .help-block')
    # 使用CSS3的同级选择器
    if $('label[for=' + labelName + '] ~ .help-block').length
      $('label[for=' + labelName + '] ~ .help-block').text(msg)
    else
      $('label[for=' + labelName + ']')?.parent().addClass('has-error')
      .append("""
        <span class="help-block">#{msg}</span>
        """)

  bindPasswordRegisterChecker: ->
    $('#new_user').submit (event) ->
      password = $('input[name="user[password]"]').val().trim()
      if password == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_password', '不能为空！')

      password_confirmation = $('#user_password_confirmation').val().trim()
      if password_confirmation == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_password_confirmation', '不能为空！')
      else if password_confirmation != password
        event.preventDefault()
        FormHelper.editHelpBlock('user_password_confirmation', '确认密码不匹配')

  bindUsernameRegisterChecker: ->
    $('#new_user').submit (event) ->
      name = $('#user_name').val().trim()
      if name == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_name', '不能为空！')

  bindDateReigisterChecker: ->
    $('#new_user').submit (event) ->
      date = $('#user_date').val().trim()
      if date != '' and !date.match(/^\d\d-\d\d$/)
        event.preventDefault()
        FormHelper.editHelpBlock('user_date', '格式不对啊！')

  bindEmailReigisterChecker: ->
    $('#new_user').submit (event) ->
      email = $('#user_email').val().trim()
      if email == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_email', '不能为空！')
      else if !email.match(/^\w+@\w+(?:\.[a-zA-Z]+)+$/)
        event.preventDefault()
        FormHelper.editHelpBlock('user_email', '邮箱地址不正确！')

  triggerModal: ->
    $('#login-modal').modal()
    $('#login-modal').on 'hidden.bs.modal', (e) ->
      $('#panel').text("刷新再来过吧。")
      $('#panel').css({
        'font-size': '40px',
        'text-align' : 'center'
      })


$(document).ready ->
  FormHelper.init()
