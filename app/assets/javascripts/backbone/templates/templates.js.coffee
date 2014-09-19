window.JST = {}
window.JST.currentMission = _.template """
  <tr class="current-mission">
    <td class="no-decoration missio-name">
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
    <td class="mission-progress-container"></td>
    <td class="btn clock-out">
      打卡
    </td>
    <% if (public) { %>
    <td class="btn private">
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

  """

window.JST.feeling = _.template """

  """

