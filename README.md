###Site Validator Gem [![travis build status](https://secure.travis-ci.org/jaimeiniesta/site_validator.png?branch=master)](http://travis-ci.org/jaimeiniesta/site_validator)

site_validator is the free, open source version of the [Site Validator app](https://sitevalidator.com).

Just pass it your site's URL and it will crawl its internal links and validate their HTML for you, generating a comprehensive validation report (see [an example](http://sitevalidator.com/gem/report.html)).

[![site_validator screencast](https://dl.dropboxusercontent.com/u/2268180/sitevalidator_gem_video.png)](https://sitevalidator.com/video_gem?autoplay=true)

For advanced features like CSS validation, deep-link crawling, results storing and team collaborations, check the awesome [Site Validator](https://sitevalidator.com/).

##Installation

site_validator is a Ruby gem that can be installed on the usual way. If you haven't Ruby installed on your system, check out [RVM](http://rvm.io/) for OSX or GNU/Linux, and [RubyInstaller](http://rubyinstaller.org/) for Windows.

    gem install site_validator

##Usage

Pass it a starting URL to be checked, and the filename where you want your report to be generated, like:

    site_validator http://validationhell.com report.html

This will validate all the internal URLs found on the starting URL, up to a maximum of 250 URLs, and generate an HTML file with the full report.

You can pass site_validator an XML sitemap or the URL of a website; it will scrape it in search of URLs to validate.

##Timeouts

By default, site_validator will set a 20 seconds timeout for each individual request. If you want to set a different timeout, pass it as a third parameter like this:

    site_validator http://validationhell.com report.html 60

##Using an alternate validation server

By default, site_validator will use the official W3C Validator server at http://validator.w3.org but you can use an alternate server if you want. To do this, define an environment variable on your machine, like:

    ENV['W3C_MARKUP_VALIDATOR_URI'] = 'http://example.com/validator'

Follow this guide to know how to setup your own validation server: https://github.com/tlvince/w3c-validator-guide

##Notes:

This gem requires Ruby 1.9, and has been tested on Ruby 1.9.2-p0

##License:

This is a free, open source project with a MIT license. See the file MIT-LICENSE for details.
