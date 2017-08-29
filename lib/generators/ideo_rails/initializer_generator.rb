# frozen_string_literal: true

require 'rails/generators/base'

module IdeoRails
  # InitializerGenerator.
  class InitializerGenerator < Rails::Generators::Base

    source_root File.expand_path('../../../templates/initializer', __FILE__)

    argument :application_name, type: :string, default: 'MyApplication'

    class_option :dev, type: :boolean, default: false

    desc 'This function initialize your Rails project with initial
    required files.'
    def create_initializer
      manage_gemfile
      manage_rubocop
      manage_environments
      manage_initializer
      manage_lib
      manage_changelog

      update_application
    end

    private

    def manage_gemfile
      # copy Gemfile
      copy_file('Gemfile', 'Gemfile')
      # add local gem if env is development
      gem 'ideo_rails', path: '../' if options[:dev]
    end

    def manage_rubocop
      # copy rubocop settings
      copy_file('.rubocop.yml', '.rubocop.yml')
    end

    def manage_environments
      # copy config environments
      copy_file('config/environments/test.rb',
                'config/environments/test.rb')
      copy_file('config/environments/development.rb',
                'config/environments/development.rb')
      copy_file('config/environments/production.rb',
                'config/environments/production.rb')
    end

    def manage_initializer
      # copy config initializers
      copy_file('config/initializers/_settings.rb',
                'config/initializers/_settings.rb')
    end

    def manage_lib
      # copy lib helpers
      copy_file('lib/apis_helpers.rb',
                'lib/apis_helpers.rb')
      copy_file('lib/models_helpers.rb',
                'lib/models_helpers.rb')
      copy_file('lib/tests_helpers.rb',
                'lib/tests_helpers.rb')
    end

    def manage_changelog
      # copy changelog
      copy_file('changelog/version_1.0',
                'changelog/version_1.0')
    end

    def update_application
      # autoload lib path
      application "config.autoload_paths += %W[\#{Rails.root}/lib]"
    end

  end
end
