class User
  attr_accessor :name,
                :difficulty,
                :total_count_attempt,
                :count_attempt,
                :total_count_hints,
                :count_hint

  def initialize(name:)
    @name = name
  end
end
