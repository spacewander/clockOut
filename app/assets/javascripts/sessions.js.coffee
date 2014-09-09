# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
FormHelper =
  init: ->
    [controller, action] = document.getElementsByTagName('body')[0].className
      .split(" ")
    return unless controller?
    switch controller
      when 'sessions-controller'
        @triggerModal()
        @bindUsernameChecker()
        @bindPasswordChecker()
      when 'users-controller'
        switch action
          when 'new-action'
            @bindUsernameRegisterChecker()
            @bindPasswordRegisterChecker()
            @bindEmailReigisterChecker()
            @bindDateReigisterChecker()
          when 'edit-action', 'update-action'
            @bindUsernameRegisterChecker()
            @bindDateReigisterChecker()
          when 'show-action'
            if !document.getElementById('others')
              @bindMissionNameChecker()
              @bindNumberInputLengthLimit()
              @bindNumberInputRangeLimit()
      else
        # do nothing
            

  # 以下部分用于登录表单
  triggerModal: ->
    $('#login-modal').modal()
    $('#login-modal').on 'hidden.bs.modal', (e) ->
      $('#panel').text("刷新再来过吧。")
      $('#panel').css({
        'font-size': '40px',
        'text-align' : 'center'
      })

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

  # 以下用于注册表单和修改用户信息表单
  # 根据标签名来给同级的help-block添加信息。注意新的信息会覆盖掉旧信息
  editHelpBlock: (labelName, msg) ->
    return if labelName == ''
    
    # 使用CSS3的同级选择器
    if $('label[for=' + labelName + '] ~ .help-block').length
      $('label[for=' + labelName + '] ~ .help-block').text(msg)
    else
      $('label[for=' + labelName + ']')?.parent().addClass('has-error')
      .append("""
        <span class="help-block">#{msg}</span>
        """)

  bindPasswordRegisterChecker: ->
    $('form').submit (event) ->
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
    $('form').submit (event) ->
      name = $('#user_name').val().trim()
      if name == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_name', '不能为空！')

  bindDateReigisterChecker: ->
    $('form').submit (event) ->
      date = $('#user_date').val().trim()
      if date != '' and !date.match(/^\d\d-\d\d$/)
        event.preventDefault()
        FormHelper.editHelpBlock('user_date', '格式不对啊！')

  bindEmailReigisterChecker: ->
    $('form').submit (event) ->
      email = $('#user_email').val().trim()
      if email == ''
        event.preventDefault()
        FormHelper.editHelpBlock('user_email', '不能为空！')
      else if !email.match(/^\w+@\w+(?:\.[a-zA-Z]+)+$/)
        event.preventDefault()
        FormHelper.editHelpBlock('user_email', '邮箱地址不正确！')

  # 以下用于创建打卡任务的表单
  repleceNotice: (msg) ->
    $('#error').text(msg)

  bindMissionNameChecker: ->
    $('#new_mission').submit (event) ->
      if $('#mission_name').val().trim() == ''
        event.preventDefault()
        FormHelper.repleceNotice('任务名不能为空！')

  bindNumberInputLengthLimit: ->
    # 注意计算input[type=number]的value时，如果存在非数字字符，那么value会清零
    # 不过这个问题不大，因为浏览器不会让这样的非法值通过的
    $('input[type=number]').keydown (event) ->
      if this.value.length >= 4
        event.preventDefault()

  bindNumberInputRangeLimit: ->
    $('#new_mission').submit (event) ->
      emptySet = $('input[type=number]').filter (idx, elem) ->
        return $(elem).val() == ''
      if emptySet.length
        event.preventDefault()
        FormHelper.repleceNotice('天数不能为空啊')
        return

      try
        mission_days = Number($('#mission_days').val())
        mission_missed_limit = Number($('#mission_missed_limit').val())
        mission_drop_out_limit = Number($('#mission_drop_out_limit').val())

        if mission_days <= 0 || mission_days > 9999
          event.preventDefault()
          FormHelper.repleceNotice('限期天数不合理！')
        if mission_missed_limit < 0 || mission_missed_limit > 9999
          event.preventDefault()
          FormHelper.repleceNotice('允许不打卡天数不合理！')
        if mission_drop_out_limit < 0 || mission_drop_out_limit > 9999
          event.preventDefault()
          FormHelper.repleceNotice('允许连续不打卡天数不合理！')
      catch e
        FormHelper.repleceNotice('捕获到了不合法的输入！')


$(document).ready ->
  FormHelper.init()
