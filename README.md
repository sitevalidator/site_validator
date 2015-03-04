###Site Validator Gem [![travis build status](https://secure.travis-ci.org/sitevalidator/site_validator.png?branch=master)](http://travis-ci.org/sitevalidator/site_validator)

site_validator is the free, open source version of the [Site Validator app](https://sitevalidator.com).

Just pass it your site's URL and it will crawl its internal links and validate their HTML for you, generating a comprehensive validation report.

[![site_validator screencast](https://dl.dropboxusercontent.com/u/2268180/sitevalidator_gem_video.png)](https://sitevalidator.wistia.com/medias/tk2nit1zdd)

For advanced features like CSS validation, deep-link crawling, results storing and team collaborations, check the awesome [Site Validator](https://sitevalidator.com/).

##Installation

site_validator is a Ruby gem that can be installed on the usual way. If you haven't Ruby installed on your system, check out [RVM](http://rvm.io/) for OSX or GNU/Linux, and [RubyInstaller](http://rubyinstaller.org/) for Windows.

    gem install site_validator

##Usage

Pass it a starting URL to be checked, and the filename where you want your report to be generated, like:

    site_validator http://validationhell.com report.html

This will validate all the internal URLs found on the starting URL, up to a maximum of 250 URLs, and generate an HTML file with the full report.

You can pass site_validator an XML sitemap or the URL of a website; it will scrape it in search of URLs to validate.

##Max pages

By default, site_validator will validate up to 100 pages per sitemap. If you want to set a different value, pass it as a third parameter like this:

    site_validator http://validationhell.com report.html 60

##Using an alternate validation server

By default, site_validator will use the official W3C Validator server at http://validator.w3.org but you can use an alternate server if you want. To do this, define an environment variable on your machine, like:

    ENV['W3C_MARKUP_VALIDATOR_URI'] = 'http://example.com/validator'

Follow this guide to know how to setup your own validation server: https://github.com/tlvince/w3c-validator-guide

##User Agent

By default, site_validator will tell the W3C validator software to use the User Agent string `Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36` instead of the default `W3C_Validator/XX.xxxx`.

I've found that some servers will produce different HTML depending on the User Agent string, and this can lead to unexpected results for the web developer that is seeing this site with a browser, but getting weird validation errors from the W3C validator, as it's seeing different HTML.

If you want to override this, you can set up you own User Agent string with an environment variable, like:

    ENV['W3C_MARKUP_VALIDATOR_USER_AGENT'] = 'W3C_Validator/1.3'

More info about the `user-agent` option on the W3C Validator can be found [here](http://validator.w3.org/docs/users.html#option-user-agent).

##Notes:

This gem is tested on Ruby 2.0.0 and 2.1.3.

##License:

This is a free, open source project with a MIT license. See the file MIT-LICENSE for details.
