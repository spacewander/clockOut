describe 'login page: ', () ->
  beforeEach () ->
    jasmine.getFixtures().set("""
    <div id="login-modal">
    <p id="error">error</p>
    <p id="notice"></p>
  <div class="clockOut-panel" id="panel">
    <div class="login modal login-form" id="login-modal">
      <form>
        <input class="form-control" id="name" name="name" type="text">
        <input class="form-control" id="password" name="password" >
        <input class="btn btn-default" name="commit" type="submit" value="登录">
      </form>
    </div>
  </div>
  </div>
      """)

  it "should check for empty username", () ->
    Sessions.bindUsernameChecker()
    $('input[name=name]').val('')
    $('input[name=commit]').click()
    expect($('#notice').text()).toBe('用户名不能为空')
    expect($('#error')).toBeHidden()

  it "should check for empty username", () ->
    Sessions.bindPasswordChecker()
    $('input[name=password]').val('')
    $('input[name=commit]').click()
    expect($('#notice').text()).toBe('密码不能为空')
    expect($('#error')).toBeHidden()
