class User
  attr_accessor :name,
                :difficulty,
                :total_count_attempt,
                :count_attempt,
                :total_count_hints,
                :count_hint

  def initialize(name:,
                 difficulty:,
                 total_count_attempt:,
                 count_attempt:,
                 total_count_hints:,
                 count_hint:)
    @name = name
    @difficulty = difficulty
    @total_count_attempt = total_count_attempt
    @count_attempt = count_attempt
    @total_count_hints = total_count_hints
    @count_hint = count_hint
  end
end
