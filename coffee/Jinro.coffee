Array::shuffle = ()->
  i = @length
  while i
    j = Math.floor(Math.random()*i);
    t = @[--i]
    @[i] = @[j]
    @[j] = t
  @

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
  result:[]

  constructor:()->
    @setJobCount()
    @setMemberName()
    @setUranaiCO()
    @setReinouCO()

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
    lines = $('#uranaiCO').val().split("\n")
    for line in lines
      stacks = line.split("/")
      name = stacks.shift()
      @uranaiCO[@name2index[name]] = []
      for uranai in stacks
        targetName = uranai.substr 0, uranai.length-1
        hantei = uranai.substr uranai.length-1, 1
        @uranaiCO[@name2index[name]].push [@name2index[targetName], (if hantei is "○" then true else false)]
  setReinouCO:()->
    lines = $('#reinouCO').val().split("\n")
    for line in lines
      stacks = line.split("/")
      name = stacks.shift()
      @reinouCO[@name2index[name]] = []
      for uranai in stacks
        targetName = uranai.substr 0, uranai.length-1
        hantei = uranai.substr uranai.length-1, 1
        @reinouCO[@name2index[name]].push [@name2index[targetName], (if hantei is "○" then true else false)]
  getRandomJob:()->
    jobs = @getJobCount()
    jobArray = []
    for jobName, num of jobs
      jobArray.push jobName for i in [0...num]
    jobArray.shuffle()
  isMurabitoSide:(jobName)->
    return false if jobName is @CONST.JOBS.JINRO
    true