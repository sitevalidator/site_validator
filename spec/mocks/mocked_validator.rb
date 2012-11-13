module SiteValidator
  class MockedValidator
    attr_accessor :errors, :warnings

    def initialize
      @errors, @warnings = [], []
    end

    def add_error(message_id, line, message)
      @errors << SiteValidator::MockedMessage.new(message_id, line, message)
    end

    def add_warning(message_id, line, message)
      @warnings << SiteValidator::MockedMessage.new(message_id, line, message)
    end
  end

  MockedMessage = Struct.new(:message_id, :line, :message)
end