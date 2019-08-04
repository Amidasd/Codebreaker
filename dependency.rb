require 'yaml'
require 'pathname'
require 'date'
require 'i18n'
require 'terminal-table'
require 'gem_codebreaker_amidasd'
require 'pry'

Dir[Dir.pwd + '/app/**/*.rb'].sort.reverse_each { |f| require f }

I18n.config.load_path << Dir[File.expand_path('./config/locales') + '/*.yml']
I18n.config.available_locales = :en
I18n.default_locale = :en

require_relative './config/app_config.rb'
# require_relative './db/b_utility.rb'
