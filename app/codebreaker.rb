class Codebreaker
  include Output

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
    if @game.status == GemCodebreakerAmidasd::STATUS[:win]
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
    array_stats = GemCodebreakerAmidasd::DbUtility.load_yaml_db
    GemCodebreakerAmidasd::DbUtility.add_in_db(array: array_stats, user: @user, game: @game)
    GemCodebreakerAmidasd::DbUtility.save_yaml_db(array_stats)
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

    return show_hint if cache_game == I18n.t(:hint)

    show_result_code(cache_game)
  end

  def show_hint
    @game.gets_hint
    output_hint(@game)
  end

  def show_result_code(cache_game)
    @game.guess_code(cache_game)
    output_guess_code_error(@game)
    return output_result_guess_code(@game) if @game.status == GemCodebreakerAmidasd::STATUS[:process_game]

    @step = :finish
  end

  def welcome
    output_welcome
    @step = :scenarios
  end

  def stats
    output_stats_table
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

    new_game
    enter_difficulty
    @step = :game if @user.name && @game.difficulty
  end

  def new_game
    @game = GemCodebreakerAmidasd::Game.new
  end

  def enter_name
    output_name
    cache_name = check_exit(false)
    @user = GemCodebreakerAmidasd::User.new(name: cache_name) if GemCodebreakerAmidasd::User.valid_name?(name: cache_name)
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
    @game.setDifficulty(cache_difficulty.to_sym) if valid_difficulty?(cache_difficulty)
  end

  def valid_difficulty?(difficulty)
    local_difficulty = {}
    @game.difficulty_hash.map { |key,| local_difficulty[I18n.t(key)] = key }
    local_difficulty[difficulty] if local_difficulty.key? difficulty
  end
end
