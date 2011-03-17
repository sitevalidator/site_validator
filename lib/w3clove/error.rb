##
# An error holds a message_id, a line and a message
#
# message_id... corresponds to the W3C messages list from http://validator.w3.org/docs/errors.html
# line......... line number where the error was detected on the page that created it
# message...... generic but descriptive text about the error
#
module W3Clove
  Error = Struct.new(:message_id, :line, :message)
end



