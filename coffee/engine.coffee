days = 10

$().ready ->
  setMember()
  init()
  #a = new Jinro()
  $('#members').on 'change', setMember
  $('#calc').on 'click', calc

calc = ->
  jr = new Jinro()

init = ->
  # 日付
  @addDayLabel()
  # 占いCO
  @addUranai(0, true)
  @addUranai(i, false) for i in [1..3]
  # 霊能CO
  @addReinou(0, true)
  @addReinou(i, false) for i in [1..3]
  # 処刑
  @addSyokei(true)
  # 死体
  @addSitai(true)


addDayLabel = ->
  tr = $('<tr>').append $('<th>')
  # 日付
  tr.append(
    $('<th>').html('名前')
  )
  for d in [1..days]
    # 日付
    tr.append(
      $('<th>').html(''+d+'日目')
    )
  $('#dayLabel').append tr

addUranai = (num, isFirst = false)->
  tr = $('<tr>')
  tr.append($('<th>').html('占いCO').attr('rowspan', 9999)) if isFirst
  tr.append(
    $('<td>').append(
      getMemberSelect('memberSelect uranaiCO uranaiCOname'+num)
    )
  )
  for d in [1..days]
    tr.append(
      $('<td>').append(
        getMemberSelect('memberSelect uranaiCO uranaiCO'+num+'_'+d)
      ).append(
        getSirokuroSelect('sirokuroSelect uranaiCO uranaiCOhantei'+num+'_'+d)
      )
    )
  $('#uranaiForm').append tr

addReinou = (num, isFirst = false)->
  tr = $('<tr>')
  tr.append($('<th>').html('霊能CO').attr('rowspan', 9999)) if isFirst
  tr.append(
    $('<td>').append(
      getMemberSelect('memberSelect reinouCO reinouCOname'+num)
    )
  )
  for d in [1..days]
    tr.append(
      $('<td>').append(
        getMemberSelect('memberSelect reinouCO reinouCO'+num+'_'+d)
      ).append(
        getSirokuroSelect('sirokuroSelect reinouCO reinouCOhantei'+num+'_'+d)
      )
    )
  $('#reinouForm').append tr

addSyokei = (isFirst = false)->
  tr = $('<tr>')
  tr.append($('<th>').html('処刑').attr('rowspan', 9999)) if isFirst
  tr.append($('<th>'))
  for d in [1..days]
    tr.append(
      $('<td>').append(
        getMemberSelect('memberSelect syokei syokei'+d)
      )
    )
  $('#syokeiForm').append tr

addSitai = (isFirst = false)->
  tr = $('<tr>')
  tr.append($('<th>').html('死体').attr('rowspan', 9999)) if isFirst
  tr.append($('<th>'))
  for d in [1..days]
    tr.append(
      $('<td>').append(
        getMemberSelect('memberSelect sitai sitai'+d)
      ).append(
        getMemberSelect('memberSelect sitai sitai'+d)
      ).append(
        getMemberSelect('memberSelect sitai sitai'+d)
      ).append(
        getMemberSelect('memberSelect sitai sitai'+d)
      )
    )
  $('#sitaiForm').append tr

setMember = ->
  $('#tempOption').html('')
  members = $('#members').val().split("\n")
  # 無選択
  $('#tempOption').append(
      $('<option>')
      .attr('value', -1)
      .html('-')
  )
  # 参加メンバー
  for i in [0...members.length]
    $('#tempOption').append(
      $('<option>')
      .attr('value', i)
      .html(members[i])
    )

  # すべての内容を変更
  $('.memberSelect').each ->
    v = $(this).val()
    $(this).html($('#tempOption').html())
    $(this).val v

getMemberSelect = (className)->
  $('#tempOption').clone().removeAttr('id').removeClass('nodisplay').addClass(className).on('change', ->
    if Number($(this).val()) isnt -1
      $(this).addClass('active')
    else
      $(this).removeClass('active')
  )
getSirokuroSelect = (className)->
  $('#tempSirokuro').clone().removeAttr('id').removeClass('nodisplay').addClass(className).on('change', ->
    if Number($(this).val()) isnt -1
      $(this).addClass('active')
    else
      $(this).removeClass('active')
  )







