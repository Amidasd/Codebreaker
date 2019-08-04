module Output
  def output_stats_table
    db = DbUtility.load_yaml_db
    rows = []
    db.users.map do |value|
      rows << [value.name, value.difficulty, value.total_count_attempt, value.count_attempt,
               value.total_count_hints, value.count_hint]
    end
    headings = ['Name', 'Difficulty', 'Total count attempt', 'Count attempt', 'Total count hints',
                'Count hint']
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
    puts game.hint if game.error.nil?
    puts I18n.t('Game.' + game.error) unless game.error.nil?
  end

  def output_guess_code(game)
    puts I18n.t('Game.' + game.error) unless game.error.nil?
    puts gets_result_guess_code(game) if game.win.nil?
    return 'finish' unless game.win.nil?
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
end
