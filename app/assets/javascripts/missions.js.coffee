# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 提取MissionLoader的公共部分。因为JS不支持通常意义上的继承，所以改用MissionLoader来调用该类实现公共部分
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

    
  # 确保totalPageNum和currentPageNum都是Number类型！
  # @param {Number} totalPageNum - 总页数
  # @param {Number} currentPageNum - 当前页码
  updatePaginationBar: (totalPageNum, currentPageNum) ->
    """
    默认是有9个页数选项，每次请求finished_missions和public_missions都返回该类资源的实际总数。
    如果 实际总数 > 9个 则显示前九个，第一个框（如果不是1）和最后的框（如果不是末尾）显示省略号（无法点选）。
    这时前页和后页会修改窗口位置，使当前窗口左边和右边正好有四个。
    注意锚点的情况。设当前页面与总页面之差为页差
    1. 当前页面大于6且页差小于5,以总页数为锚点。从右往左，页数递减
    2. 当前页面小于6，则页差不小于5,以第1页为锚点，无需修改页面
    3. 当前页面大于6且页差不小于5,则没有锚点，当前页面位于中间，左边依次为-4, -3, -2, -1。右边同理。
    如果 实际总数 <= 9，显示实际总数个。按需隐藏框。
    如果 实际总数 <= 1，隐藏
    """
    # 重置省略号为隐藏状态
    $('#left-ellipsis').hide()
    $('#right-ellipsis').hide()

    # 重置页数
    for i in [1..9]
      pageItem = $("li[data-num=#{i}]")
      # 更新当前页面的标识
      pageItem.children().text(i)
      
    if totalPageNum < 2
      $('#pagination').hide()
    else if 2 <= totalPageNum <= 9
      for i in [(totalPageNum + 1)..9]
        $("li[data-num=#{i}]").hide()

    else
      # totalPageNum > 9
      pageGap = totalPageNum - currentPageNum
      if currentPageNum >= 6
        # jQuery默认的show动作不能添加正确的display属性的值
        $('#left-ellipsis').css('display', 'inline')
        if pageGap < 5
          for i in [0...9]
            $("li[data-num=#{9 - i}] > a").text(String(totalPageNum - i))

      if pageGap >= 5
        $('#right-ellipsis').css('display', 'inline')

      if currentPageNum >= 6 && pageGap >= 5
        basePage = currentPageNum - 5
        for i in [1..9]
          $("li[data-num=#{i}] > a").text(String(basePage + i))
        
    # 根据当前页码重新设置可用性
    for i in [1..9]
      pageItem = $("li[data-num=#{i}]")
      if pageItem.children().text() == String(currentPageNum)
        pageItem.addClass('active')
      else
        pageItem.removeClass('active')

    # 根据当前页码，设置前一页和后一页的可用性
    if currentPageNum == 1
      $('#last-page').addClass('disabled')
    else
      $('#last-page').removeClass('disabled')
    if currentPageNum == totalPageNum
      $('#next-page').addClass('disabled')
    else
      $('#next-page').removeClass('disabled')
 
# users#show页面交互内容
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
      
  # 根据页数来获取对应的finished missions
  fetchPageNum: (pageNum) ->
    MissionLoader.fetchFinishedMissions(pageNum)

  fetchLast: () ->
    active = $('li.active')
    $("li[data-num=#{Number(active.attr('data-num')) - 1}]").click()

  fetchNext: () ->
    active = $('li.active')
    $("li[data-num=#{Number(active.attr('data-num')) + 1}]").click()

  # 监听分页模块的点击事件
  addPaginationListener: ->
    $("#last-page").click (event) ->
      UserShowAction.fetchLast() if !$(this).hasClass('disabled')
    $("#next-page").click (event) =>
      UserShowAction.fetchNext() if !$(this).hasClass('disabled')

    for i in [1..9]
      $("li[data-num=#{i}]").click (event) ->
        # 时时刻刻确保只有一个页码处于active状态
        $("li.page-num").each (idx, elem) ->
          $(elem).removeClass('active')
        $(this).addClass('active')
        UserShowAction.fetchPageNum($(this).children().text())


$(document).ready ->
  if $('.users-controller.show-action').length
    MissionLoader.init()

    UserShowAction.preventReload()
    UserShowAction.addPaginationListener()

    $('#finished-missions-panel > .drop').click (event) ->
      isCurrentMissionsHidden = $('#current-missions-panel:hidden').length
      isFinishedMissionsHidden = $('#finished-missions-panel:hidden').length
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

