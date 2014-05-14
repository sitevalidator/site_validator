# -*- encoding: utf-8 -*-

require_relative '../lib/site_validator'
require_relative './mocks/mocked_validator'
require 'mocha'
require 'fakeweb'

$samples_dir = File.dirname(__FILE__) + '/samples'
FakeWeb.register_uri(:get, "http://ryanair.com/sitemap.xml", :response => open("#{$samples_dir}/sitemap.xml").read)
FakeWeb.register_uri(:get, "http://example.com/sitemap_dirty.xml", :response => open("#{$samples_dir}/sitemap_dirty.xml").read)
FakeWeb.register_uri(:get, "http://example.com/dirty", :response => open("#{$samples_dir}/dirty.html").read)
FakeWeb.register_uri(:get, "http://guides.rubyonrails.org", :response => open("#{$samples_dir}/guides.rubyonrails.org.html").read)
FakeWeb.register_uri(:get, "http://eparreno.com", :response => open("#{$samples_dir}/eparreno.com.html").read)
FakeWeb.register_uri(:get, "http://www.eparreno.com", :response => open("#{$samples_dir}/eparreno.com.html").read)
FakeWeb.register_uri(:get, "http://zigotica.com", :response => open("#{$samples_dir}/zigotica.com.html").read)
FakeWeb.register_uri(:get, "http://protocol-relative.com", :response => open("#{$samples_dir}/protocol_relative.html").read)
FakeWeb.register_uri(:get, "https://protocol-relative.com", :response => open("#{$samples_dir}/protocol_relative.html").read)
FakeWeb.register_uri(:get, "http://example.com/exclusions", :response => open("#{$samples_dir}/exclusions.html").read)
FakeWeb.register_uri(:get, "http://example.com/exclusions.xml", :response => open("#{$samples_dir}/exclusions.xml").read)
FakeWeb.register_uri(:get, "http://markupvalidator.com/faqs", :response => open("#{$samples_dir}/markup_validator_faqs.response").read)
FakeWeb.register_uri(:get, "http://example.com/international", :response => open("#{$samples_dir}/international.response").read)
FakeWeb.register_uri(:get, "http://github.com", :response => open("#{$samples_dir}/http_github.response").read)
FakeWeb.register_uri(:get, "https://github.com", :response => open("#{$samples_dir}/https_github.response").read)
FakeWeb.register_uri(:get, "https://unsafe.com", :response => open("#{$samples_dir}/https_unsafe_redirect.response").read)
FakeWeb.register_uri(:get, "http://unsafe.com",  :response => open("#{$samples_dir}/http_unsafe_redirect.response").read)

def message_text(message_id)
  message_texts = {
    '25' => 'general entity "B" not defined and no default entity',
    '325' => 'reference to entity "B" for which no system identifier could be generated',
    '65' => 'document type does not allow element "P" here; missing one of "APPLET", "OBJECT", "MAP", "IFRAME", "BUTTON" start-tag',
    '338' => 'cannot generate system identifier for general entity "B"',
    '247' => 'NET-enabling start-tag requires SHORTTAG YES'
  }
  message_texts[message_id]
end

def stubbed_validator_results(with_errors=true, with_warnings=true)
  fake_validator = SiteValidator::MockedValidator.new

  if with_errors
    fake_validator.add_error('25',  '92',   '22', message_text('25'),   'a code snippet for line 92',         "an explanation for error 25 <p class='helpwanted'><a href='#'>feedback</a></p>")
    fake_validator.add_error('325', '92',   '22', message_text('325'),  'another code snippet for line 92',   "an explanation for error 325 <p class='helpwanted'><a href='#'>feedback</a></p>")
    fake_validator.add_error('325', '224',  '17', message_text('325'),  'another code snippet for line 325',  "an explanation for error 325 <p class='helpwanted'><a href='#'>feedback</a></p>")
  end

  if with_warnings
    fake_validator.add_warning('338', '92',   '22', message_text('338'), 'a code snippet for line 338',       "an explanation for warning 338 <p class='helpwanted'><a href='#'>feedback</a></p>")
    fake_validator.add_warning('247', '112',  '18', message_text('247'), 'another code snippet for line 247', "an explanation for warning 247 <p class='helpwanted'><a href='#'>feedback</a></p>")
    fake_validator.add_warning('247', '202',  '47', message_text('247'), 'another code snippet for line 247', "an explanation for warning 247 <p class='helpwanted'><a href='#'>feedback</a></p>")
  end

  fake_validator
end
