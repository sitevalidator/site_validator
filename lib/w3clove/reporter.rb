# -*- encoding: utf-8 -*-

require 'erb'

module W3Clove
  module Reporter
    extend self

    ##
    # Create the html report for the sitemap
    def generate_html(sitemap)
      template = ERB.new(open(File.dirname(__FILE__)+'/templates/w3clove.html.erb').read)

      File.open('w3clove.html', 'w') do |f|
        f.write(template.result(sitemap.get_binding))
      end
    rescue Exception => e
      puts "ERROR generating report: #{e}"
    end
  end
end
