require "thor"
require "natto"
require "rhymer/lyric"
require "rhymer/parser"
require "rhymer/version"

module Rhymer
  class CLI < Thor
    desc 'spit TEXT', 'Detect and print rhymes in the TEXT'
    def spit(text)
      parser = Parser.new(text)
      parser.rhymes.each do |rhyme|
        puts "#{rhyme[0]} #{rhyme[1]}"
      end
    end

    desc '-v, --version', 'Print the version'
    map %w(-v --version) => :version
    def version
      puts "rhymer #{Rhymer::VERSION}"
    end
  end
end
