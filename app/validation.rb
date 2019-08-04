module Validation
  def validtion_name(name)
    name.is_a?(String) && !name.empty? && name.length.between?(3, 20)
  end

  def validtion_difficulty(difficulty)
    [I18n.t(:easy), I18n.t(:medium), I18n.t(:hell)].include? difficulty
  end
end
