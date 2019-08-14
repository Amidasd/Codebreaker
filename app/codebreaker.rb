class Codebreaker
  include Output

  PATH_DB = './db/codebreaker_db.yml'.freeze

  COMMANDS = {
    welcome: :welcome,
    start: :start,
    exit: :close,
    scenarios: :scenarios,
    rules: :rules,
    stats: :stats,
    game: :step_game,
    finish: :finish,
    save: :save
  }.freeze

  AVAILABLE_COMMANDS = %i[start stats rules exit].freeze

  attr_reader :step, :game, :user

  def initialize
    @step = :welcome
  end

  def run
    loop do
      next send(COMMANDS[@step]) if COMMANDS.key?(@step)
      step_else
    end
  end

    private

  def close
    output_exit
    exit
  end

  def finish
    output_step_finish(@game.string_secretcode)
    if @game.win
      output_won
      @step = :save
    else
      output_lose
      empty_game
      @step = :scenarios
    end
  end

  def save
    output_save
    cache_save = check_exit
    case cache_save
    when I18n.t('Game.y') then save_game
    when I18n.t('Game.n') then @step = :scenarios
    end
    empty_game
  end

  def save_game
    @user.set_params(difficulty: @game.difficulty, total_count_attempt: @game.total_count_attempt,
                     count_attempt: @game.count_attempt, total_count_hints: @game.total_count_hints,
                     count_hint: @game.array_hints.size)
    GemCodebreakerAmidasd::DbUtility.add_db(@user, PATH_DB)
    empty_game
    @step = :scenarios
  end

  def empty_game
    @game = nil
    @user = nil
  end

  def step_else
    output_else
    @step = :scenarios
  end

  def step_game
    output_start_game
    cache_game = check_exit
    return if @step == :exit

    if cache_game == I18n.t(:hint)
      @game.gets_hint
      output_hint(@game)
    else
      @game.guess_code(cache_game)
      result = output_guess_code(@game)
      @step = :finish if result == :finish
    end
  end

  def welcome
    output_welcome
    @step = :scenarios
  end

  def stats
    output_stats_table(PATH_DB)
    @step = :scenarios
  end

  def rules
    output_rules
    @step = :scenarios
  end

  def scenarios
    output_scenarios
    comamand = gets.chomp.downcase
    return @step = comamand.to_sym if AVAILABLE_COMMANDS.include?(comamand.to_sym)

    @step = :else
  end

  def start
    return enter_name if !@user || !@user.name

    @game ||= GemCodebreakerAmidasd::GemCodebreaker.new
    enter_difficulty
    @step = :game if @user.name && @game.difficulty
  end

  def enter_name
    output_name
    cache_name = check_exit(false)
    @user = GemCodebreakerAmidasd::User.new(name: cache_name) if GemCodebreakerAmidasd::User.validtion_name(cache_name)
  end

  def check_exit(downcase = true)
    cache_name = gets.chomp
    @step = :exit if cache_name.downcase == I18n.t(:exit)
    return cache_name.downcase if downcase
    return cache_name unless downcase
  end

  def enter_difficulty
    output_difficalty
    @game.difficulty_hash.map do |key,|
      output_variant_difficalty(key)
    end
    cache_difficulty = check_exit
    @game.set_difficulty(cache_difficulty.to_sym) if validtion_difficulty(cache_difficulty)
  end

  def validtion_difficulty(difficulty)
    local_difficulty = {}
    @game.difficulty_hash.map { |key,| local_difficulty[I18n.t(key)] = key }
    local_difficulty[difficulty] if local_difficulty.key? difficulty
    end
  end
