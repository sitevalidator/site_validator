module SiteValidator
  class MockedValidator
    attr_accessor :errors, :warnings

    def initialize
      @errors, @warnings = [], []
    end

    def checked_by
      "w3c_validator"
    end

    def add_error(message_id, line, col, message, source, explanation)
      @errors << SiteValidator::MockedMessage.new(message_id, line, col, message, source, explanation)
    end

    def add_warning(message_id, line, col, message, source, explanation)
      @warnings << SiteValidator::MockedMessage.new(message_id, line, col, message, source, explanation)
    end
  end

  MockedMessage = Struct.new(:message_id, :line, :col, :message, :source, :explanation)
end
