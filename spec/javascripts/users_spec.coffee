describe 'users#index', () ->
  it 'getPercentsFromMissions ok', () ->
    correct = User.getPercentsFromMissions('20', '100')
    expect(correct).toEqual(20)
    dividedByZero = User.getPercentsFromMissions('10', '0')
    expect(dividedByZero).toEqual(0)
    wrong = User.getPercentsFromMissions('20', '10')
    expect(wrong).toEqual(0)

  it 'generalProgressBar ok', () ->
    expect(User.generalProgressBar(0)).toBe(User.progressbarDetail(0))
    expect(User.generalProgressBar(101)).toBe('')

