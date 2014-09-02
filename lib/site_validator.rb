# -*- encoding: utf-8 -*-

require_relative 'site_validator/version'
require_relative 'site_validator/validator'
require_relative 'site_validator/sitemap'
require_relative 'site_validator/page'
require_relative 'site_validator/message'
require_relative 'site_validator/reporter'

module SiteValidator
  USER_AGENT = ENV['W3C_MARKUP_VALIDATOR_USER_AGENT'] || "SiteValidator/#{SiteValidator::VERSION} Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36"
end
