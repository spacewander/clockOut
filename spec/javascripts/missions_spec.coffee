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

 # hack for global value to be used in every test
  view = null
  collection = null

  beforeEach () ->
    jasmine.getFixtures().set("""
    <tbody id="current-missions">
    </tbody>
    """)

    view = new CurrentMissionView()
    collection = new CurrentMissionsCollection(view)
    collection.add(mission1)
    collection.add(mission2)

  it "should push a mission into the collection", () ->
    expect(collection.get(2).get('name')).toBe 'test'

  it "should append current view when missions are added", () ->
    expect($('.current-mission').length).toEqual(2)

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
    expect($('.current-mission[data-id=2]').hasClass('aborted')).toEqual true
    expect($('.current-mission[data-id=1]').hasClass('aborted')).toEqual false
    
  it "should clock out after click .clock-out", () ->
    $('.current-mission[data-id=2] > .clock-out').click()
    expect($('.current-mission[data-id=2] > .finished-days').text()).toBe '11'
    expect($('.current-mission[data-id=2] .drop-out-days').text()).toBe '0'
    expect($('.current-mission[data-id=1] > .finished-days')
      .text().trim()).toBe '13'
    expect($('.current-mission[data-id=1] .drop-out-days').text()).toBe '1'
    

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
    <tbody id="finished-missions"></tbody>
    """)

    finishedView = new FinishedMissionView()
    finishedCollection = new FinishedMissionCollection(finishedView)
    finishedCollection.add(mission3)
    finishedCollection.add(mission4)

  it "should append finished view when missions are added", () ->
    console.log $('#finished-missions').html()
    expect($('.finished-mission').length).toEqual(2)
    expect($('.mission-result').length).toEqual(2)

  it "should have correct result for finished view", () ->
    expect($('.finished-mission[data-id=3] .mission-result').text().trim())
      .toBe '成功'
    expect($('.finished-mission[data-id=4] .mission-result').text().trim())
      .toBe '失败'
