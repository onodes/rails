# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }

require 'rubygems'
gem "rack", "~> 1.0.0"
gem "rack-test", "~> 0.5.0"

require 'test/unit'
require 'active_support/core_ext/kernel/requires'

# AP is always present
require 'action_controller/test_case'
require 'action_view/test_case'
require 'action_dispatch/test_case'

require 'action_mailer/test_case' if defined?(ActionMailer)
require 'active_model/test_case'  if defined?(ActiveModel)

if defined?(ActiveRecord)
  require 'active_record/test_case'
  require 'active_record/fixtures'

  class ActiveSupport::TestCase
    include ActiveRecord::TestFixtures
    self.fixture_path = "#{Rails.root}/test/fixtures/"
    self.use_instantiated_fixtures  = false
    self.use_transactional_fixtures = true
  end

  ActionController::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

  def create_fixtures(*table_names, &block)
    Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
  end
end

begin
  require_library_or_gem 'ruby-debug'
  Debugger.start
  if Debugger.respond_to?(:settings)
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
  end
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end
