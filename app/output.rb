module Output
  def output_stats_table(path)
    db = GemCodebreakerAmidasd::DbUtility.load_yaml_db(path)
    rows = []
    db.map do |value|
      rows << [value.name, value.difficulty, value.total_count_attempt, value.count_attempt,
               value.total_count_hints, value.count_hint]
    end
    headings = [I18n.t(:name), I18n.t(:difficulty), I18n.t(:total_count_attempt), I18n.t(:count_attempt),
                I18n.t(:total_count_hints), I18n.t(:count_hint)]
    table = Terminal::Table.new headings: headings, rows: rows
    puts table
  end

  def output_welcome
    puts I18n.t(:step_welcome)
  end

  def output_save
    puts I18n.t('Game.save_result')
  end

  def output_won
    puts I18n.t('Game.Won')
  end

  def output_lose
    puts I18n.t('Game.Lose')
  end

  def output_exit
    puts I18n.t(:step_exit)
  end

  def output_else
    puts I18n.t(:unexpected_command)
  end

  def output_step_finish(code)
    puts I18n.t(:step_finish) << code
  end

  def output_start_game
    puts I18n.t('Game.start_game')
  end

  def output_hint(game)
    puts game.hint unless game.error
    puts I18n.t('Game.' + game.error.to_s) if game.error
  end

  def output_guess_code(game)
    puts I18n.t('Game.' + game.error.to_s) if game.error
    puts gets_result_guess_code(game) if game.win.nil?
    return :finish unless game.win.nil?
  end

  def gets_result_guess_code(game)
    I18n.t(:symbol_plus) * game.count_plus << I18n.t(:symbol_minus) * game.count_minus
  end

  def output_rules
    puts I18n.t(:step_rules)
  end

  def output_scenarios
    puts I18n.t(:step_scenarios)
  end

  def output_difficalty
    puts I18n.t(:choose_difficulty)
  end

  def output_variant_difficalty(key)
    puts '-' << I18n.t(key)
  end

  def output_name
    puts I18n.t(:enter_name)
  end
end
