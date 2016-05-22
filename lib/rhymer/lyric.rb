module Rhymer
  class Lyric
    def initialize(text)
      @lyric = []
      mecab.parse(text) do |m|
        @lyric << m
      end
    end

    def mecab
      @mecab ||= Natto::MeCab.new
    end

    def lyric
      @lyric
    end

    def nauns
      nauns = {}
      lyric.each_with_index do |term, index|
        if term.feature.split(",")[0] == "名詞"
          nauns.store(index, term)
        end
      end
      nauns
    end
  end
end
