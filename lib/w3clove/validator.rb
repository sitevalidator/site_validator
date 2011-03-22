# -*- encoding: utf-8 -*-

module W3Clove
  ##
  # Validator module is the one in charge of doing the validation loop
  # for all pages on a sitemap and output the errors
  #
  module Validator
    attr_writer :printer

    extend self

    ##
    # Parses a remote xml sitemap and checks markup validation for each url
    # Shows progress on dot-style (...F...FFE..). A dot is a page with no errors,
    # an F is a page with errors, and an E is an exception
    # After the checking is done, a detailed summary is shown
    def check(url)
      sitemap = W3Clove::Sitemap.new(url)
      say "Validating #{sitemap.pages.length} pages..."

      sitemap.pages.each do |page|
        say_inline page.valid? ? "." : (page.errors.nil? ? 'E' : 'F')
      end

      show_results(sitemap)
    end

    private

    ##
    # Outputs the results of the validation
    def show_results(sitemap)
      show_sitemap_summary(sitemap)
      show_popular_errors(sitemap)
      show_popular_errors(sitemap)
      say "\n\nDETAILS PER PAGE"
      sitemap.pages.select {|page| !page.errors.empty?}.each do |p|
        show_page_summary(p)
      end
    end

    def show_sitemap_summary(sitemap)
      <<HEREDOC
SITEMAP SUMMARY
TOTAL: #{sitemap.errors.length} errors, #{sitemap.warnings.length} warnings
HEREDOC
    end

    def show_popular_errors(sitemap)
      say "\n\nMOST POPULAR ERRORS\n"
      sitemap.errors.group_by {|e| e.message_id}.sort_by {|m,e| e.length}.reverse.each do |message_id, errors|
        say "error #{message_id} happens #{errors.length} times"
      end
    end

    def show_popular_warnings(sitemap)
      say "\n\nMOST POPULAR WARNINGS\n"
      sitemap.warnings.group_by {|e| e.message_id}.sort_by {|m,e| e.length}.reverse.each do |message_id, warnings|
        say "warning #{message_id} happens #{warnings.length} times"
      end
    end

    def show_page_summary(page)
      say "\n  ** #{page.url} **"
      "    #{page.errors.length} errors, #{page.warnings.length} warnings"
      page.errors.each do |error|
        say "\n    Error #{error.message_id} on line #{error.line}:"
        say "    #{error.text}"
      end

      page.warnings.each do |warning|
        say "\n    Warning #{warning.message_id} on line #{warning.line}:"
        say "    #{warning.text}"
      end
    end

    def printer
      @printer ||= STDOUT
    end

    ##
    # A shorter alias for printer.puts
    def say(text)
      printer.puts text
    end

    ##
    # A shorter alias for printer.print
    def say_inline(text)
      printer.print text
    end
  end
end