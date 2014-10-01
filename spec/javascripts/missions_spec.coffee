describe 'Current Mission : ', () ->
  mission1 =
    id: 1
    name: 'name'
    finishedDays: 13
    days: 100
    missedDays: 3
    missedLimit: 10
    dropOutDays: 1
    dropOutLimit: 5
    public: true
    supervised: false
    # 注意mission1已经打卡过了
    canClockOut: false

  mission2 =
    id: 2
    name: 'test'
    finishedDays: 10
    days: 100
    missedDays: 3
    missedLimit: 10
    dropOutDays: 1
    dropOutLimit: 5
    public: false
    supervised: false
    canClockOut: true

 # hack for global value to be used in every test
  view = null
  collection = null

  beforeEach () ->
    jasmine.getFixtures().set("""
    <table id="current-missions-table">
      <tbody id="current-missions"> </tbody>
    </table>
    """)

    view = new CurrentMissionView()
    view.role = 'hoster'
    view.insertThead()
    collection = new CurrentMissionsCollection(view)
    collection.add(mission1)
    collection.add(mission2)

  it "should push a mission into the collection", () ->
    expect(collection.get(2).get('name')).toBe 'test'

  it "should append current view when missions are added", () ->
    expect($('.current-mission').length).toEqual(2)

  it "会插入当前任务表的表头", ->
    expect($('#current-missions-table thead').length).toEqual 1

  it "不会重复插入表头", ->
    currentView = new CurrentMissionView()
    currentView.insertThead()
    expect($('#current-missions-table thead').length).toEqual 1

  it "should have public button when mission.public is false", () ->
    expect($('.public').length).toEqual(1)

  it "should have private button when mission.public is true", () ->
    expect($('.private').length).toEqual(1)

  it "should show correct percents in .finished-percents", () ->
    expect($('.current-mission[data-id=1] .finished-percents > span.sr-only')
      .text()).toBe '13%'
    expect($('.current-mission[data-id=2] .finished-percents > span.sr-only')
      .text()).toBe '10%'

  it "should abort after click .abort", () ->
    $('.current-mission[data-id=2] > .abort').click()
    # 现在要想abort掉某个任务需要用confirm向用户获取确认，所以无法进行测试
    #expect($('.current-mission[data-id=2]').hasClass('aborted')).toEqual true
    #expect($('.current-mission[data-id=1]').hasClass('aborted')).toEqual false
    
  it "should clock out after click .clock-out", () ->
    $('.current-mission[data-id=2] .clock-out').click()
    expect($('.current-mission[data-id=2] > .finished-days').text().trim())
      .toBe '11'
    expect($('.current-mission[data-id=2] .drop-out-days').text()).toBe '0'
    expect($('.current-mission[data-id=1] > .finished-days')
      .text().trim()).toBe '13'
    expect($('.current-mission[data-id=1] .drop-out-days').text()).toBe '1'
    
  it "已打卡的项目不会显示打卡按钮，而会显示已打卡按钮", ->
    expect($('.current-mission[data-id=1]').children('.clock-out').length)
      .toEqual 0
    expect($('.current-mission[data-id=1]').children('.has-clocked-out').length)
      .toEqual 1

  # 没有测试未打卡的项目在打卡后，会切换到已打卡状态。因为这个测试需要等服务器端的回调

  it "should publish after click .property-btn if used to be private", () ->
    $('.current-mission[data-id=2] .private').click()
    # toggle public / private
    expect($('.current-mission[data-id=2] > .property-btn')
      .hasClass('private')).toEqual false
    expect($('.current-mission[data-id=2] > .property-btn')
      .hasClass('public')).toEqual true
    expect($('.current-mission[data-id=2] > .property-btn > .btn').text())
      .toBe "公开"

  it "should privatize after click .property-btn if used to be public", () ->
    $('.current-mission[data-id=1] .public').click()
    # toggle public / private
    expect($('.current-mission[data-id=1] > .property-btn')
      .hasClass('private')).toEqual true
    expect($('.current-mission[data-id=1] > .property-btn')
      .hasClass('public')).toEqual false
    expect($('.current-mission[data-id=1] > .property-btn > .btn').text())
      .toBe "私有"

  it "should hide all four funtional buttons for visitor", () ->
    # reset fixture
    jasmine.getFixtures().set """
    <table id="current-missions-table">
      <tbody id="current-missions"> </tbody>
    </table>
    """

    view.role = 'visitor'
    view.insertThead()
    collection = new CurrentMissionsCollection(view)
    collection.add(mission1)
    expect($('.abort').length).toEqual 0
    expect($('.public').length).toEqual 0
    expect($('.supervised').length).toEqual 0
    expect($('.clock-out').length).toEqual 0


describe 'Finished Mission : ', () ->
  mission3 =
    id: 3
    name: 'finished'
    finishedDays: 100
    days: 100
    missedDays: 3
    missedLimit: 10
    dropOutDays: 1
    dropOutLimit: 5
    public: false
    supervised: false
    finished: true
    aborted: false

  mission4 =
    id: 4
    name: 'aborted'
    finishedDays: 10
    days: 100
    missedDays: 10
    missedLimit: 10
    dropOutDays: 1
    dropOutLimit: 5
    public: false
    supervised: false
    finished: true
    aborted: true

  finishedView = null
  finishedCollection = null

  beforeEach () ->
    jasmine.getFixtures().set("""
    <div class="table-responsive none" id="finished-missions-table" >
        <table class="table table-hover">
          <tbody id="finished-missions"></tbody>
        </table>
    </div>
    """)

    finishedView = new FinishedMissionView()
    finishedView.insertThead()
    finishedCollection = new FinishedMissionCollection(finishedView)
    finishedCollection.add(mission3)
    finishedCollection.add(mission4)

  it "should append finished view when missions are added", () ->
    expect($('.finished-mission').length).toEqual(2)
    expect($('.mission-result').length).toEqual(2)

  it "会插入表头", ->
    expect($('#finished-missions-table thead').length).toEqual 1

  it "不会重复插入表头", ->
    finishedView = new FinishedMissionView()
    finishedView.insertThead()
    expect($('#finished-missions-table thead').length).toEqual 1

  it "should have correct result for finished view", () ->
    expect($('.finished-mission[data-id=3] .mission-result').text().trim())
      .toBe '成功'
    expect($('.finished-mission[data-id=4] .mission-result').text().trim())
      .toBe '失败'

