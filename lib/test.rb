require_relative 'site_validator'

page = SiteValidator::Page.new('http://proofs13.issl.co.uk/')
puts page.errors.size