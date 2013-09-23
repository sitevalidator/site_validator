module SiteValidator
  class MockedValidator
    attr_accessor :errors, :warnings

    def initialize
      @errors, @warnings = [], []
    end

    def add_error(message_id, line, message, source)
      @errors << SiteValidator::MockedMessage.new(message_id, line, message, source)
    end

    def add_warning(message_id, line, message, source)
      @warnings << SiteValidator::MockedMessage.new(message_id, line, message, source)
    end
  end

  MockedMessage = Struct.new(:message_id, :line, :message, :source)
end
