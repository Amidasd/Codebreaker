class DbUtility
  class << self
    def save_yaml_db(user)
      yml_db = CodebreakerConfig::PATH_DB
      File.write(yml_db, user.to_yaml)
    end

    def load_yaml_db
      yml_db = CodebreakerConfig::PATH_DB
      return unless File.exist?(yml_db)

      YAML.load_file(yml_db)
    end

    def add_db(user)
      db = load_yaml_db
      db = Statistics.new unless db.is_a?(Statistics)
      db.add_object(user)
      db.users = db.users.sort_by { |value| [value.total_count_attempt, value.count_attempt, value.count_hint] }
      save_yaml_db(db)
    end
  end
end
