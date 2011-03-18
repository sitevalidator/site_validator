# -*- encoding: utf-8 -*-

require_relative '../lib/w3clove'

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
