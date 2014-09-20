# Model
class Mission extends Backbone.Model
  urlRoot: '/missions'

  defaults:
    # Warning: if the id is the same with any other Mission,
    # it will not trigger add event
    id: 0
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
    percents: 0

# Collection
class MissionsCollection extends Backbone.Collection
  model: Mission
  url: '/missions'

  initialize: (view) ->
    @view = view

  # 计算完成率，用于进度条的显示
  calculatePercents: (mission) ->
    days = mission.get('days')
    finishedDays = mission.get('finishedDays')

    if days == 0
      mission.set('percents', 0)
    else
      try
        if finishedDays <= days
          mission.set('percents', finishedDays * 100 / days)
        else
          throw new Error('打卡天数不能超过所需打卡天数')
      catch e
        mission.set('percents', 0)


class CurrentMissionsCollection extends MissionsCollection
  initialize: (view) ->
    super.initialize(view)
    @on 'add', (mission) ->
      @calculatePercents(mission)
      @view.addCurrentMission(mission)


class FinishedMissionCollection extends MissionsCollection
  initialize: (view) ->
    super.initialize(view)
    @on 'add', (mission) ->
      @calculatePercents(mission)
      @view.addFinishedMission(mission)

