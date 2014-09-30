describe 'CommonMissionLoader#updatePaginationBar will', ->
  beforeEach () ->
    jasmine.getFixtures().set("""
   <ul class="pagination" id="pagination">
        <li id="last-page" class="page-action"><a>&laquo;</a></li>
        <li class="ellipsis" id="left-ellipsis"><a>...</a></li>
        <li data-num="1" class="page-num"><a>1</a></li>
        <li data-num="2" class="page-num"><a>2</a></li>
        <li data-num="3" class="page-num"><a>3</a></li>
        <li data-num="4" class="page-num"><a>4</a></li>
        <li data-num="5" class="page-num"><a>5</a></li>
        <li data-num="6" class="page-num"><a>6</a></li>
        <li data-num="7" class="page-num"><a>7</a></li>
        <li data-num="8" class="page-num"><a>8</a></li>
        <li data-num="9" class="page-num"><a>9</a></li>
        <li class="ellipsis" id="right-ellipsis"><a>...</a></li>
        <li id="next-page" class="page-action"><a>&raquo;</a></li>
      </ul>
    """)

  it "hide #pagination when totalPageNum < 2", ->
    CommonMissionLoader.updatePaginationBar(1, 1)
    expect($('#pagination').css('display')).toBe 'none'

  it "当页数不小于2且不大于9,显示跟页数一样多的列", ->
    CommonMissionLoader.updatePaginationBar(4, 1)
    # should be 1(active) 2 3 4
    # visible 和 hidden 选择器貌似在PhatomJS中不起作用，所以只好hack
    expect($('li.page-num')
    .filter (idx, elem) ->
      $(elem).css('display') != 'none'
    .length).toEqual 4
    expect($('li.page-num.active > a').text()).toBe '1'

  it "当页数大于9时，当前页面大于6且页差小于5,最右边为总页面。 从右往左，页数递减", ->
    CommonMissionLoader.updatePaginationBar(10, 7)
    # should be ... 2 3 4 5 6 7(active) 8 9 10
    expect($('li.page-num').length).toEqual 9
    expect($('#left-ellipsis').css('display')).not.toBe 'none'
    expect($('li.page-num.active > a').text()).toBe '7'
    expect($('li[data-num=9] > a').text()).toBe '10'
    expect($('li[data-num=8] > a').text()).toBe '9'
    expect($('li[data-num=1] > a').text()).toBe '2'
    expect($('#right-ellipsis').css('display')).toBe 'none'

  it "当页面大于9时，当前页面小于6。以第一页为开始，无需修改", ->
    CommonMissionLoader.updatePaginationBar(10, 4)
    # should be 1 2 3 4(active) 5 6 7 8 9 ...
    expect($('li.page-num').length).toEqual 9
    expect($('#left-ellipsis').css('display')).toBe 'none'
    expect($('li.page-num.active > a').text()).toBe '4'
    expect($('li[data-num=9] > a').text()).toBe '9'
    expect($('li[data-num=2] > a').text()).toBe '2'
    expect($('li[data-num=1] > a').text()).toBe '1'
    expect($('#right-ellipsis').css('display')).not.toBe 'none'

  it "当页面大于9时，当前页面大于6且页差不小于5。当前页面位于正中", ->
    CommonMissionLoader.updatePaginationBar(12, 7)
    # should be ... 3 4 5 6 7(active) 8 9 10 11 ...
    expect($('li.page-num').length).toEqual 9
    expect($('#left-ellipsis').css('display')).not.toBe 'none'
    expect($('li.page-num.active > a').text()).toBe '7'
    expect($('li[data-num=9] > a').text()).toBe '11'
    expect($('li[data-num=8] > a').text()).toBe '10'
    expect($('li[data-num=2] > a').text()).toBe '4'
    expect($('li[data-num=1] > a').text()).toBe '3'
    expect($('#right-ellipsis').css('display')).not.toBe 'none'

  it "当当前页码为1时，禁止前一页;当前页面为最末页时，禁止后一页。否则两个方向的翻页均可用", ->
    CommonMissionLoader.updatePaginationBar(12, 1)
    expect($('#last-page').hasClass('disabled')).toEqual true
    expect($('#next-page').hasClass('disabled')).toEqual false
    CommonMissionLoader.updatePaginationBar(12, 12)
    expect($('#last-page').hasClass('disabled')).toEqual false
    expect($('#next-page').hasClass('disabled')).toEqual true
    CommonMissionLoader.updatePaginationBar(12, 4)
    expect($('#last-page').hasClass('disabled')).toEqual false
    expect($('#next-page').hasClass('disabled')).toEqual false
    CommonMissionLoader.updatePaginationBar(12, 1)
    expect($('#last-page').hasClass('disabled')).toEqual true
    expect($('#next-page').hasClass('disabled')).toEqual false
    
