# Model
class Mission extends Backbone.Model
  urlRoot: '/missions'

  defaults:
    id: 1
    name: ''
    content: ''
    finishedDays: 0
    days: 30
    dropOutDays: 0
    dropOutLimit: 5
    missedDays: 0
    missedLimit: 10
    public: false
    supervised: false
    aborted: false
    finished: false

# Collection
class CurrentMissionsCollection extends Backbone.Collection
  model: Mission
  url: '/missions'

  initialize: (view) ->
    @view = view
    @on 'add', (mission) ->
      @view.addCurrentMission(mission)

