#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

require 'open-uri/cached'

class MemberRow < Scraped::HTML
  field :district do
    td[0].text.tidy
  end

  field :name do
    name_link.text.tidy
  end

  field :id do
    name_link.attr('wikidata')
  end

  private

  def td
    noko.css('td')
  end

  def name_link
    td[1].css('a').first
  end
end

class MembersPage < Scraped::HTML
  decorator WikidataIdsDecorator::Links

  field :members do
    member_rows.map { |p| fragment(p => MemberRow).to_h }
  end

  private

  def member_rows
    table.xpath('.//tr[td]')
  end

  def table
    noko.xpath('//h3[contains(.,"List of members")]/following::table').first
  end
end

url = 'https://en.wikipedia.org/wiki/Texas_House_of_Representatives'
data = MembersPage.new(response: Scraped::Request.new(url: url).response).members

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
