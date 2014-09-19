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

class MissionsCollection extends Backbone.Collection
  model: Mission
  url: '/missions'

class CurrentMission extends Mission
  defaults:
    public: false
    supervised: false
    aborted: false
    finished: false

class FinishedMission extends Mission
  defaults:
    public: false
    supervised: false
    aborted: false
    finished: true
