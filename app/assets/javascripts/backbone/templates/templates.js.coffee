window.JST = {}
missionTemplate = """
    <td class="no-decoration mission-name">
      <%= name %>
      <a href="missions/<%= id %>" alt="<%= content %>"></a>
    </td>
    <td class="finished-days">
      <%= finishedDays %>
    </td>
    <td class="days">
      <%= days %>
    </td>
    <td class="missed">
      <span class="missed-days first-item"><%= missedDays %></span>
        /
      <span class="missed-limit second-item"><%= missedLimit %></span>
    </td>
    <td class="drop-out">
      <span class="drop-out-days first-item"><%= dropOutDays %></span>
        /
      <span class="drop-out-limit second-item"><%= dropOutLimit %></span>
    </td>
    <td class="mission-progress-container">
      <div class="progress">
        <div class="progress-bar progress-bar-success finished-percents"
          role="progressbar"
          aria-valuenow="<%= percents %>" aria-valuemin="0" aria-valuemax="100"
          style="width: <%= percents %>%">
          <span class="sr-only"><%= percents %>%</span>
        </div>
      </div>
    </td>
"""

window.JST.currentMission = _.template """
  <tr class="current-mission" data-id="<%= id %>">
    #{missionTemplate}
    <td class="btn clock-out">
      打卡
    </td>
    <% if (public) { %>
    <td class="btn private none">
      私有
    <% } else { %>
    <td class="btn public">
      公开
    <% } %>
    </td>
    <td class="btn supervised">
      监督
    </td>
    <td class="btn abort">
      弃疗
    </td>
  </tr>
  """

window.JST.finishedMission = _.template """
  <tr class="finished-mission" data-id="<%= id %>">
  #{missionTemplate}
  <td colspan="4" class="mission-result">
  <% if (aborted) { %>
    失败
  <% } else { %>
    成功
  <% } %>
  </td>
  """

window.JST.feeling = _.template """

  """

