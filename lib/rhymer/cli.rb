require "thor"
require "natto"
require "rhymer/lyric"
require "rhymer/parser"

module Rhymer
  class CLI < Thor
    desc 'spit TEXT', 'Detect and print rhymes in the TEXT'
    def spit(text)
      parser = Parser.new(text)
      parser.rhymes.each do |rhyme|
        puts "#{rhyme[0]} #{rhyme[1]}"
      end
    end
  end

  CLI.start
end
