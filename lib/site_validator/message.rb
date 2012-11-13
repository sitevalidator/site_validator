# -*- encoding: utf-8 -*-

module SiteValidator
  ##
  # A message holds a message_id, a line, a text and a type
  #
  # See the W3C message explanation list on
  # http://validator.w3.org/docs/errors.html
  Message = Struct.new(:message_id, :line, :text, :type)
end