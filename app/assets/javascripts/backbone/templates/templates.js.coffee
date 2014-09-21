window.JST = {}
missionTemplate = """
    <td class="mission-name">
      <a class="no-decoration" href="/missions/<%= id %>" alt="<%= content %>">
        <%= name %>
      </a>
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
"""

window.JST.currentMission = _.template """
  <tr class="current-mission" data-id="<%= id %>">
    #{missionTemplate}
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
    <% if (role === 'hoster') { %>
    <td class="clock-out">
      <div class="btn btn-success">打卡</div>
    </td>
    <% if (public) { %>
    <td class="private">
      <div class="btn btn-warning">私有</div>
    <% } else { %>
    <td class="public">
      <div class="btn btn-warning">公开</div>
    <% } %>
    </td>
    <td class="supervised">
      <div class="btn btn-info">监督</div>
    </td>
    <td class="abort">
      <div class="btn btn-danger">弃疗</div>
    </td>
    <% }  else { %>
    <td colspan="4"></td>
    <% } %>
  </tr>
  """

window.JST.finishedMission = _.template """
  <% if (aborted) { %>
  <tr class="finished-mission danger" data-id="<%= id %>">
  <% } else { %>
  <tr class="finished-mission success" data-id="<%= id %>">
  <% } %>
  #{missionTemplate}
  <td class="mission-progress-container">
    <div class="progress">
      <% if (aborted) { %>
      <div class="progress-bar progress-bar-danger finished-percents"
        role="progressbar"
        aria-valuenow="<%= percents %>" aria-valuemin="0" aria-valuemax="100"
        style="width: <%= percents %>%">
      <% } else { %>
      <div class="progress-bar progress-bar-success finished-percents"
        role="progressbar"
        aria-valuenow="<%= percents %>" aria-valuemin="0" aria-valuemax="100"
        style="width: <%= percents %>%">
      <% } %>
        <span class="sr-only"><%= percents %>%</span>
      </div>
    </div>
  </td>
  <td colspan="1" class="mission-result center">
  <% if (aborted) { %>
    <span class="fail">失败</span>
  <% } else { %>
    <span class="success">成功</span>
  <% } %>
  </td>
  """

window.JST.feeling = _.template """

  """

