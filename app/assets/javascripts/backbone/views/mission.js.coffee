class window.CurrentMissionView extends Backbone.View
  template: JST.currentMission
  el: '#current-missions'
  # 设置视图权限，不同用户使用的模板有些许不同
  role: ''

  insertThead: ()->
    # 如果之前已经有视图类进行了插入，则不再重新插入
    if !$('#current-missions-table > thead').length
      tableHeader = JST.currentThead(
        role : @role
      )
      $('#current-missions-table').prepend(tableHeader)

  events:
    'click .clock-out' : 'triggerClockOut'
    'click .abort' : 'triggerAbort'
    'click .property-btn' : 'triggerPublish'

    
  cleanAll: () ->
    @$el.html('')

  # currentMission here is currentMission Object
  addCurrentMission: (currentMission) ->
    attributes = currentMission.attributes
    attributes.role = @role
    @$el.append(@template(attributes))
    @$el

  removeCurrentMission: (currentMission) ->
    $(".current-mission[data-id=#{currentMission.id}]").remove()
    @$el

  # trigger开头的方法负责在触发服务器端之前修改客户端的数据
  # 再交由对应的方法触发服务器端，并完成回调后对界面的修改
  triggerClockOut: (event) ->
    currentMission = $(event.currentTarget).parent('.current-mission')
    finishedDays = $(currentMission.children('.finished-days'))
    try
      now = Number(finishedDays.text()) + 1
      finishedDays.text(String(now))
    catch e
      # do nothing
    try
      $(currentMission.find('.drop-out-days')).text('0')
    catch e
      # do nothing
    finally
      @clockOut(currentMission)

  triggerAbort: (event) ->
    currentMission = $(event.currentTarget).parent()
    if confirm('你真的打算放弃这项任务吗？是否承认失败？')
      currentMission.addClass('aborted')
      @abort(currentMission)

  triggerPublish: (event) ->
    # 可能是点击公开按钮触发，也可能是点击隐藏按钮触发
    currentMission = $(event.currentTarget).parent()
    currentMission.children('.property-btn').toggleClass('public private')
    currentMission.find('.public > .btn')?.text('公开')
    currentMission.find('.private > .btn')?.text('私有')

    @publish(currentMission)

  # currentMission here is the html element which is the target mission
  # 即使客户端的数据修改失败，依然会从服务器端获取最新的数据获取最新的数据
  abort: (currentMission) ->
    $.get "/missions/#{currentMission.attr('data-id')}/abort", (data) ->
      if data.err
        console.log "abort mission #{currentMission.attr('data-id')} failed"
        console.log data.err
    , 'json'
      .fail ->
        console.log "abort mission #{id} failed"


  clockOut: (currentMission) ->
    id = currentMission.attr('data-id')
    $.get "/missions/#{id}/clockout", (data) ->
      if data.err
        console.log "clockOut mission #{id} failed"
        console.log data.err
      else if data.id # 更新成功了
        currentMission.find('.clock-out > .btn').text('已打卡')
        currentMission.children('.clock-out')
          .toggleClass('clock-out has-clocked-out')
        
    , 'json'
      .fail ->
        console.log "clockOut mission #{id} failed"

  publish: (currentMission) ->
    id = currentMission.attr('data-id')
    $.get "/missions/#{id}/publish", (data) =>
      if data.err
        console.log "publish mission #{id} failed"
        console.log data.err
      else if data.id # 更新成功了
        if currentMission.children('.private').length && @role == 'visitor'
          currentMission.hide()
    , 'json'
      .fail ->
        console.log "publish mission #{id} failed"


class window.FinishedMissionView extends Backbone.View
  template: JST.finishedMission
  el: '#finished-missions'
  # 设置视图权限，不同用户使用的模板有些许不同
  role: ''

  insertThead: ()->
    # 如果之前已经有视图类进行了插入，则不再重新插入
    if !$('#finished-missions-table thead').length
      tableHeader = JST.finishedThead()
      $('#finished-missions-table > table').prepend(tableHeader)


  cleanAll: () ->
    @$el.html('')

  addFinishedMission: (finishedMission) ->
    attributes = finishedMission.attributes
    attributes.role = @role
    @$el.append(@template(attributes))
    @$el

  removeCurrentMission: (finishedMission) ->
    $(".finished-mission[data-id=#{finishedMission.id}]").remove()
    @$el

