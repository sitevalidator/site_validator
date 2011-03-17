##
# A message holds a message_id, a line, a text and a type
#
# message_id... corresponds to the W3C messages list from http://validator.w3.org/docs/errors.html
# line......... line number where the error was detected on the page that created it
# text......... generic but descriptive text about the error
# type......... can be :error or :warning
#
module W3Clove
  Message = Struct.new(:message_id, :line, :text, :type)
end