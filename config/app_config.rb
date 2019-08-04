# frozen_string_literal: true

module CodebreakerConfig
  DIFFICULTY_HASH = {
    I18n.t(:easy) => { total_count_attempt: 15, total_count_hints: 2 },
    I18n.t(:medium) => { total_count_attempt: 10, total_count_hints: 1 },
    I18n.t(:hell) => { total_count_attempt: 5, total_count_hints: 1 }
  }.freeze

  AVAILABLE_COMMANDS = { 'start' => :start, 'stats' => :stats, 'rules' => :rules, 'exit' => :exit }.freeze

  PATH_DB = './db/codebreaker_db.yml'
end
