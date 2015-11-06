Array::shuffle = ()->
  i = @length
  while i
    j = Math.floor(Math.random()*i);
    t = @[--i]
    @[i] = @[j]
    @[j] = t
  @

uranai = 0
reinou = 0


class Jinro
  CONST:
    JOBS:
      MURABITO : "murabito"
      URANAI   : "uranai"
      REINO    : "reino"
      KARIUDO  : "kariudo"
      KYOUYU   : "kyouyu"
      NEKOMATA : "nekomata"
      JINRO    : "jinro"
      KYOJIN   : "kyojin"
      YOUKO    : "youko"
      HAITOKU  : "haitoku"
  memberCount:null
  jobCount:null
  index2name:{}
  name2index:{}
  uranaiCO:{}
  reinouCO:{}
  syokei:{}
  sitai:{}
  result:[]

  constructor:()->
    @setJobCount()
    @setMemberName()
    @setUranaiCO()
    @setReinouCO()
    @setSyokei()
    @setSitai()

  calc:(count)->
    @initResult()

    for i in [0...count]
      jobs = @getRandomJob()
      if @judge jobs
        @result[memberIndex][job]++ for job, memberIndex in jobs

  judge:(jobs)->
    for jobName, memberIndex in jobs
      switch jobName
        when @CONST.JOBS.MURABITO
          return false unless @checkMurabito jobs, memberIndex
        when @CONST.JOBS.URANAI
          return false unless @checkUranai jobs, memberIndex
        when @CONST.JOBS.REINO
          return false unless @checkReinou jobs, memberIndex
        when @CONST.JOBS.KARIUDO
          return false unless @checkKariudo jobs, memberIndex
        when @CONST.JOBS.KYOUYU
          return false unless @checkKyouyu jobs, memberIndex
        when @CONST.JOBS.NEKOMATA
          return false unless @checkNekomata jobs, memberIndex
        when @CONST.JOBS.JINRO
          return false unless @checkJinro jobs, memberIndex
        when @CONST.JOBS.KYOJIN
          return false unless @checkKyojin jobs, memberIndex
        when @CONST.JOBS.YOUKO
          return false unless @checkYouko jobs, memberIndex
        when @CONST.JOBS.HAITOKU
          return false unless @checkHaitoku jobs, memberIndex
    true

  # 村人チェック
  checkMurabito:(jobs, memberIndex)->
    # 占いCOしてたら嘘
    return false if @uranaiCO[memberIndex]?
    # 霊能COしてたら嘘
    return false if @reinouCO[memberIndex]?
    # 真の可能性あり
    true

  # 占いチェック
  checkUranai:(jobs, memberIndex)->
    # 占いCOしてなかったら嘘
    return false unless @uranaiCO[memberIndex]?
    # 占いチェック
    for value in @uranaiCO[memberIndex]
      [targetIndex, isMurabito] = value
      # 占い結果が矛盾していれば嘘
      return false if @isMurabitoSide(jobs[targetIndex]) isnt isMurabito
    # 真の可能性あり
    true

  # 霊能チェック
  checkReinou:(jobs, memberIndex)->
    # 霊能COしてなかったら嘘
    return false unless @reinouCO[memberIndex]?
    # 霊能チェック
    for value in @reinouCO[memberIndex]
      [targetIndex, isMurabito] = value
      # 霊能結果が矛盾していれば嘘
      return false if @isMurabitoSide(jobs[targetIndex]) isnt isMurabito
    # 真の可能性あり
    true

  # 狩人チェック
  checkKariudo:(jobs, memberIndex)->
    # 占いCOしてたら嘘
    return false if @uranaiCO[memberIndex]?
    # 霊能COしてたら嘘
    return false if @reinouCO[memberIndex]?
    # 真の可能性あり
    true

  # 共有チェック
  checkKyouyu:(jobs, memberIndex)->
    # 占いCOしてたら嘘
    return false if @uranaiCO[memberIndex]?
    # 霊能COしてたら嘘
    return false if @reinouCO[memberIndex]?
    # 真の可能性あり
    true

  # 猫又チェック
  checkNekomata:(jobs, memberIndex)->
    # 占いCOしてたら嘘
    return false if @uranaiCO[memberIndex]?
    # 霊能COしてたら嘘
    return false if @reinouCO[memberIndex]?
    # 真の可能性あり
    true
  # 人狼チェック
  checkJinro:(jobs, memberIndex)->


  # 狂人チェック
  checkKyojin:(jobs, memberIndex)->
    # 占いCOしてたら嘘
    return false if @uranaiCO[memberIndex]?
    # 霊能COしてたら嘘
    return false if @reinouCO[memberIndex]?
    # 真の可能性あり
    true

  # 妖狐チェック
  checkYouko:(jobs, memberIndex)->
    # 真の可能性あり
    true

  # 背徳者チェック
  checkHaitoku:(jobs, memberIndex)->
    # 真の可能性あり
    true

  initResult:()->
    @result = []

    jobSet = {}
    jobSet[value] = 0 for key, value of @CONST.JOBS
    for i in [0...@memberCount]
      @result[i] = jobSet

  setMemberName:()->
    @index2name = $('#jinmei').val().split("\n")
    memberCount = 0
    for value, key in @index2name
      @name2index[value] = key
      memberCount++
    @memberCount = memberCount

  setJobCount:()->
    res = {}
    for value, key of @CONST.JOBS
      res[value] = Number $('#'+value).val()
    @jobCount = res

  setUranaiCO:()->
    for memberIndex in [0...4]
      continue if $('.uranaiCOname'+memberIndex).val() < 0
      @uranaiCO[memberIndex] = []
      for day in [0...10]
        targetIndex = $('.uranaiCO'+memberIndex+'_'+day).val()
        hantei = $('.uranaiCOhantei'+memberIndex+'_'+day).val()
        continue if targetIndex < 0 or hantei < 0
        @uranaiCO[memberIndex].push [targetIndex, (if hantei is 0 then true else false)]

  setReinouCO:()->
    for memberIndex in [0...4]
      continue if $('.reinouCOname'+memberIndex).val() < 0
      @reinouCO[memberIndex] = []
      for day in [0...10]
        targetIndex = $('.reinouCO'+memberIndex+'_'+day).val()
        hantei = $('.reinouCOhantei'+memberIndex+'_'+day).val()
        continue if targetIndex < 0 or hantei < 0
        @reinouCO[memberIndex].push [targetIndex, (if hantei is 0 then true else false)]

  setSyokei:()->
    for day in [0...10]
      @syokei[day] = []

      syokeiIndex = $('.syokei'+d).val()
      @syokei[day].push syokeiIndex if syokeiIndex < 0

  setSitai:()->
    for day in [0...10]
      @sitai[day] = []

      selects = $('.sitai'+d)
      for s in selects
        syokeiIndex = s.val()
        continue if syokeiIndex < 0
        @syokei[day].push syokeiIndex

  getRandomJob:()->
    jobs = @getJobCount()
    jobArray = []
    for jobName, num of jobs
      jobArray.push jobName for i in [0...num]
    jobArray.shuffle()
  isMurabitoSide:(jobName)->
    return false if jobName is @CONST.JOBS.JINRO
    true