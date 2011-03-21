# -*- encoding: utf-8 -*-

require_relative '../lib/w3clove'
require_relative './mocks/mocked_validator'
require 'mocha'

$samples_dir = File.dirname(__FILE__) + '/samples'

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

def stubbed_validator_results
  fake_validator = W3Clove::MockedValidator.new

  fake_validator.add_error('25', '92', message_text('25'))
  fake_validator.add_error('325', '92', message_text('325'))
  fake_validator.add_error('325', '224', message_text('325'))

  fake_validator.add_warning('338', '92', message_text('338'))
  fake_validator.add_warning('247', '112', message_text('247'))
  fake_validator.add_warning('247', '202', message_text('247'))

  fake_validator
end