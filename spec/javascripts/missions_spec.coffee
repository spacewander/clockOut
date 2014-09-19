describe 'Current Mission : ', () ->
  beforeEach () ->
    jasmine.getFixtures().set("""
    <tbody id="current-missions">
    </tbody>
    """)

  it "should append view when a CurrentMission is added", () ->
    mission =
      id: 2
      name: 'test'
      finishedDays: 10
      days: 30
      missedDays: 3
      missedLimit: 10
      dropOutDays: 1
      dropOutLimit: 5
      public: false
      supervised: false

    view = new CurrentMissionView()
    collection = new CurrentMissionsCollection(view)
    collection.add(mission)
    expect(collection.get(2).get('name')).toBe 'test'
    expect($('.current-mission').length).toEqual(1)

