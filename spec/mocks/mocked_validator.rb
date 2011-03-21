module W3Clove
  class MockedValidator
    attr_accessor :errors, :warnings

    def initialize
      @errors, @warnings = [], []
    end

    def add_error(message_id, line, message)
      @errors << W3Clove::MockedMessage.new(message_id, line, message)
    end

    def add_warning(message_id, line, message)
      @warnings << W3Clove::MockedMessage.new(message_id, line, message)
    end
  end

  MockedMessage = Struct.new(:message_id, :line, :message)
end