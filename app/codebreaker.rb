class Codebreaker
  include Validation
  include Output

  attr_reader :name, :difficulty, :step, :game

  def initialize
    @step = :welcome
  end

  def start
    loop do
      case @step
      when :exit then break step_close
      when :welcome then step_welcome
      when :scenarios then step_scenarios
      when :rules then step_rules
      when :stats then step_stats
      else start_two
      end
    end
  end

  def start_two
    case @step
    when :start then step_start
    when :game then step_game
    when :finish then step_finish
    when :save then step_save
    else step_else
    end
  end

  private

  def step_close
    output_exit
    exit
  end

  def step_finish
    output_step_finish(@game.secret_code.join(''))
    if @game.win
      output_won
      @step = :save
    else
      output_lose
      empty_game
      @step = :scenarios
    end
  end

  def step_save
    output_save
    cache_save = check_exit
    case cache_save
    when I18n.t('Game.y') then save_game
    when I18n.t('Game.n') then @step = :scenarios
    end
    empty_game
  end

  def save_game
    user = User.new(name: @name, difficulty: @difficulty, total_count_attempt: @game.total_count_attempt,
             count_attempt: @game.count_attempt, total_count_hints: @game.total_count_hints,
             count_hint: @game.array_hints.size)
    DbUtility.add_db(user)
    empty_game
    @step = :scenarios
  end

  # def create_user
  #   User.new(name: @name, difficulty: @difficulty, total_count_attempt: @game.total_count_attempt,
  #                   count_attempt: @game.count_attempt, total_count_hints: @game.total_count_hints,
  #                   count_hint: @game.array_hints.size)
  # end

  def empty_game
    @game = nil
    @name = nil
    @difficulty = nil
  end

  def step_else
    output_else
    @step = :scenarios
  end

  def step_game
    output_start_game
    cache_game = check_exit
    return if @step == :exit

    new_game
    if cache_game == 'hint'
      @game.gets_hint
      output_hint(@game)
    else
      @game.guess_code(cache_game)
      result = output_guess_code(@game)
      @step = :finish if result == 'finish'
    end
  end

  def new_game
    if @game.nil?
      @game = GemCodebreakerAmidasd::GemCodebreaker.new(CodebreakerConfig::DIFFICULTY_HASH[@difficulty][:total_count_attempt],
                            CodebreakerConfig::DIFFICULTY_HASH[@difficulty][:total_count_hints])
    end
  end

  def step_welcome
    output_welcome
    @step = :scenarios
  end

  def step_stats
    output_stats_table
    @step = :scenarios
  end

  def step_rules
    output_rules
    @step = :scenarios
  end

  def step_scenarios
    output_scenarios
    comamand = gets.chomp.downcase
    @step = CodebreakerConfig::AVAILABLE_COMMANDS[comamand]
  end

  def step_start
    if @name.nil?
      enter_name
      return
    else
      enter_difficulty
    end
    @step = :game if !@name.nil? && !@difficulty.nil?
  end

  def enter_name
    puts I18n.t(:enter_name)
    cache_name = check_exit(false)
    @name = cache_name if validtion_name(cache_name)
  end

  def check_exit(downcase = true)
    cache_name = gets.chomp
    @step = :exit if cache_name.downcase == 'exit'
    return cache_name.downcase if downcase
    return cache_name unless downcase
  end

  def enter_difficulty
    puts I18n.t(:choose_difficulty)
    cache_difficulty = check_exit
    @difficulty = cache_difficulty if validtion_difficulty(cache_difficulty)
  end
end
