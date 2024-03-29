# frozen_string_literal: true

require 'yaml'
require 'paygate/version'
require 'paygate/configuration'
require 'paygate/aes'
require 'paygate/aes_ctr'
require 'paygate/member'
require 'paygate/response'
require 'paygate/transaction'
require 'paygate/profile'

if defined?(Rails)
  require 'paygate/rails/engine'
  require 'paygate/rails/form_helper'
end

module Paygate
  extend self

  CONFIG = YAML.safe_load(File.read(File.expand_path('../data/config.yml', __dir__)),
                          permitted_classes: [Symbol]).freeze
  (LOCALES_MAP = CONFIG[:locales].freeze).each { |k, v| k.freeze; v.freeze } # rubocop:disable Style/Semicolon
  (INTL_BRANDS_MAP = CONFIG[:intl_brands].freeze).each_value(&:freeze)
  (KOREA_BIN_NUMBERS = CONFIG[:korea_bin_numbers].freeze).each(&:freeze)
  DEFAULT_CURRENCY = 'WON'
  DEFAULT_LOCALE = 'US'

  def mapped_currency(currency)
    currency = currency&.to_s
    return DEFAULT_CURRENCY if currency.nil?

    currency.to_s == 'KRW' ? 'WON' : currency.to_s
  end

  def mapped_locale(locale)
    LOCALES_MAP[locale&.to_s] || DEFAULT_LOCALE
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end
end
