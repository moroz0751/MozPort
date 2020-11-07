require './spec/support/helpers/factory_bot_helper'
require './spec/support/helpers/debug_helper'
require 'database_cleaner/active_record'


RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include FactoryBotHelper
  config.include DebugHelper

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(
      :truncation,
      except: %w(ar_internal_metadata)
    )
  end

  config.before :each do 
    DatabaseCleaner.start
    FactoryBot.rewind_sequences
  end

  config.after :each do 
    DatabaseCleaner.clean_with(
      :truncation,
      except: %w(ar_internal_metadata)
    )
  end

  # config.around(:each) do |example|
  #   DatabaseCleaner.cleaning do
  #     example.run
  #   end
  # end
end