class window.Feeling extends Backbone.Model
  urlRoot: '/feelings'

  defaults:
    createdAt: new Date()
    missionId: 1
    content: ''
    dayName: '第一天'

class window.FeelingsCollection extends Backbone.Collection
  model: Feeling
  url: '/feelings'
