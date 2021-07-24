#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :district do
      noko.xpath('text()').text.gsub('District', '').tidy
    end

    field :name do
      noko.css('a strong').text.gsub('Rep.', '').split(',').reverse.join(' ').tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
                      .sort_by { |row| row[:district].to_s.to_i }
    end

    private

    def member_container
      noko.css('#members td.members-img-center')
    end
  end
end

url = 'https://house.texas.gov/members/'
puts EveryPoliticianScraper::ScraperData.new(url).csv
