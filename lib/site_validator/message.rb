# -*- encoding: utf-8 -*-

module SiteValidator
  ##
  # A message holds a message_id, a line, a text a type
  # and a source (for the code snippet)
  #
  # See the W3C message explanation list on
  # http://validator.w3.org/docs/errors.html
  Message = Struct.new(:message_id, :line, :col, :text, :type, :source, :explanation)
end
