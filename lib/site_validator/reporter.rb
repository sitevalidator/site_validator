# -*- encoding: utf-8 -*-

require 'erb'

module SiteValidator
  module Reporter
    extend self

    ##
    # Create the html report for the sitemap
    def generate_html(sitemap, filename)
      template = ERB.new(open(File.dirname(__FILE__)+'/templates/site_validator.html.erb').read)

      File.open(filename, 'w') do |f|
        f.write(template.result(sitemap.get_binding))
      end
    rescue Exception => e
      puts "ERROR generating report: #{e}"
    end
  end
end
