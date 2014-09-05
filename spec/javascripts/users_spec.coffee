describe 'users#index', () ->
  it 'getPercentsFromMissions ok', () ->
    correct = User.getPercentsFromMissions('20', '100')
    expect(correct).toEqual(20)
    dividedByZero = User.getPercentsFromMissions('10', '0')
    expect(dividedByZero).toEqual(0)
    wrong = User.getPercentsFromMissions('20', '10')
    expect(wrong).toEqual(0)

  it 'generalProgressBar ok', () ->
    expect(User.generalProgressBar(0)).toBe("""
<div class="progress">
  <div class="progress-bar progress-bar-striped active"  role="progressbar"
    aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"
    style="width: 0%">
    <span class="sr-only">0%</span>
  </div>
</div>
      """)
    expect(User.generalProgressBar(101)).toBe('')

