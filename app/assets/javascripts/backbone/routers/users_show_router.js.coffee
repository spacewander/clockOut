# the backbone router used in users#show page
# router map: 注意只给finished Mission 做路由
# users/1
# -> users/1#finishedMissions/1 (when show with finished missions of page 1)
class window.UsersRouter extends Backbone.Router
  initialize: (options) ->


  routes:
    'finishedMissions/:page' : 'finished'

  # @param {String} page - The page number of finishedMissions
  finished: (page) ->
    page = Number(page)
    if page > 0
      MissionLoader.fetchFinishedMissions(page)

