#!/usr/bin/env ruby

require 'csv'
require './stats'

data = CSV.read("raw_data.csv", headers: true, converters: :numeric)

column_index = data.headers.each_with_index.inject({}) do |h, (header, idx)|
  h.merge!({header => idx})
end

cols_to_scrub = %w(Sleep_Hours_Schoolnight Doing_Homework_Hours
  Video_Games_Hours Social_Websites_Hours Texting_Messaging_Hours
  Social_Websites_Hours Computer_Use_Hours Watching_TV_Hours)

col_stats = Hash.new {|h,k| h[k] = Stats.new}

data.each do |row|
  # Collect data
  cols_to_scrub.each do |col|
    col_stats[col] << row[col] if !row[col].nil?
  end
end

col_scrubs = Hash.new{|h,k| h[k] = 0}

puts data.headers.to_csv
data.each do |row|
  cols_to_scrub.each do |col|
    datum = row[col]
    if !datum.nil?
      s = col_stats[col]
      if datum < s.mean - s.stddev * 1.5 || datum > s.mean + s.stddev * 1.5
        col_scrubs[col] += 1
        row[col] = nil
      end
    end
  end
  puts row.to_csv
end

$stderr.puts "SCRUBBINGS: #{col_scrubs.inspect}"
