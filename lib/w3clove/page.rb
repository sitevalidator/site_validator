##
# A page has an URL to be validated, and a collection of errors
#
module W3Clove
  class Page
    require 'w3c_validators'
    include W3CValidators

    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def errors
      @errors ||= validation_results.errors.map {|e| W3Clove::Message.new(e.message_id, e.line, e.message, :error)}
    end

    def warnings
      @warnings ||= validation_results.warnings.map {|w| W3Clove::Message.new(w.message_id, w.line, w.message, :warning)}
    end

    private

    def validation_results
      @validation_results ||= MarkupValidator.new.validate_uri(url)
    end
  end
end