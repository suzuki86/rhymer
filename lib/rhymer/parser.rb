module Rhymer
  class Parser
    VIBES_THRESHOLD_DEFAULT = 4
    PREFIX_LENGTH_DEFAULT = 4

    attr_reader :lyric, :rhymes

    def initialize(text, config = { :vibes_threshold => VIBES_THRESHOLD_DEFAULT, :prefix_length => PREFIX_LENGTH_DEFAULT })
      text = remove_symbols(text)
      @lyric = Lyric.new(text)
      @rhymes = []
      consonants = []

      @lyric.nouns.each do |noun|
        consonants << {
          :position => noun[0],
          :noun => romanize(noun[1].feature.split(",")[7])
        }
      end

      rhymes = []
      consonants.combination(2) do |arr|
        score = vibes(arr.first[:noun], arr.last[:noun])
        if
          arr.first[:noun] != arr.last[:noun] &&
          score > config[:vibes_threshold]
        then
          rhymes << {
            :first => arr.first[:position],
            :second => arr.last[:position],
            :vibes => score,
          }
        end
      end

      rhymes.each do |rhyme|
        prefixes = [[], []]

        %w(first second).each_with_index do |label, n|
          counter = 0
          (rhyme[label.to_sym] - 1).step(0, -1) do |i|

            parts_of_speech = @lyric.lyric[i].feature.split(",")[0]
            kind_of_parts_of_speech = @lyric.lyric[i].feature.split(",")[1]
            previous_parts_of_speech = @lyric.lyric[i - 1].feature.split(",")[0]
            further_previous_parts_of_speech = @lyric.lyric[i - 2].feature.split(",")[0]

            if prefixes[n].length > 0
              latest_stored_parts_of_speech = prefixes[n][0][:term].feature.split(",")[0]
            end

            if n > 1 && i <= rhyme[:first]
              break
            end

            if
              counter > config[:prefix_length] &&
              latest_stored_parts_of_speech != "助動詞" &&
              latest_stored_parts_of_speech != "助詞" &&
              latest_stored_parts_of_speech != "動詞" &&
              previous_parts_of_speech != "名詞" &&
              previous_parts_of_speech != "連体詞" &&
              parts_of_speech != "名詞" &&
              parts_of_speech != "連体詞"
            then
              break
            end

            if
              kind_of_parts_of_speech == "句点" ||
              kind_of_parts_of_speech == "読点"
            then
              break
            end

            if
              parts_of_speech == "名詞" ||
              parts_of_speech == "接頭詞" ||
              parts_of_speech == "動詞" ||
              parts_of_speech == "接続詞" ||
              parts_of_speech == "形容詞" ||
              parts_of_speech == "連体詞"
            then
              prefixes[n].unshift({
                :position => i,
                :term => @lyric.lyric[i]
              })
            end

            if
              (
                parts_of_speech == "助詞" &&
                previous_parts_of_speech != "記号"
              ) ||
              (
                parts_of_speech == "助動詞" &&
                previous_parts_of_speech != "記号"
              )
            then
              prefixes[n].unshift({
                :position => i,
                :term => @lyric.lyric[i]
              })
            end

            if 
              previous_parts_of_speech != "名詞" &&
              previous_parts_of_speech != "動詞" &&
              previous_parts_of_speech != "連体詞" &&
              further_previous_parts_of_speech == "記号"
            then
              break
            end

            counter = counter + 1
          end

        end

        prefix_surfaces = ["", ""]
        prefixes.each_with_index do |prefix, i|
          prefix.each do |p|
            prefix_surfaces[i] = prefix_surfaces[i] + p[:term].surface
          end
        end

        if prefix_surfaces[0].empty? || prefix_surfaces[1].empty?
          next
        end

        @rhymes << [
          prefix_surfaces[0] + @lyric.lyric[rhyme[:first]].surface,
          prefix_surfaces[1] + @lyric.lyric[rhyme[:second]].surface,
          rhyme[:vibes]
        ]
      end

      @rhymes = @rhymes.sort_by {|a, b, c| c }.reverse
    end

    def remove_html(text)
      text.gsub(/<\/?[^>]*>/, "")
    end

    def remove_symbols(text)
      text.gsub(/\[.+?\]/, "")
    end

    def romanize(term)
      {
        "キャ" => "kya",
        "キュ" => "kyu",
        "キョ" => "kyo",
        "シャ" => "sya",
        "シュ" => "syu",
        "ショ" => "syo",
        "チャ" => "tya",
        "チュ" => "tyu",
        "チョ" => "tyo",
        "ニャ" => "nya",
        "ニュ" => "nyu",
        "ニョ" => "nyo",
        "ヒャ" => "hya",
        "ヒュ" => "hyu",
        "ヒョ" => "hyo",
        "ミャ" => "mya",
        "ミュ" => "myu",
        "ミョ" => "myo",
        "リャ" => "rya",
        "リュ" => "ryu",
        "リョ" => "ryo",
        "ギャ" => "gya",
        "ギュ" => "gyu",
        "ギョ" => "gyo",
        "ジャ" => "jya",
        "ジュ" => "jyu",
        "ジョ" => "jyo",
        "ビャ" => "bya",
        "ビュ" => "byu",
        "ビョ" => "byo",
        "ピャ" => "pya",
        "ピュ" => "pyu",
        "ピョ" => "pyo",
        "カ" => "ka",
        "キ" => "ki",
        "ク" => "ku",
        "ケ" => "ke",
        "コ" => "ko",
        "サ" => "sa",
        "シ" => "si",
        "ス" => "su",
        "セ" => "se",
        "ソ" => "so",
        "タ" => "ta",
        "チ" => "ti",
        "ツ" => "tu",
        "テ" => "te",
        "ト" => "to",
        "ナ" => "na",
        "ニ" => "ni",
        "ヌ" => "nu",
        "ネ" => "ne",
        "ノ" => "no",
        "ハ" => "ha",
        "ヒ" => "hi",
        "フ" => "hu",
        "ヘ" => "he",
        "ホ" => "ho",
        "マ" => "ma",
        "ミ" => "mi",
        "ム" => "mu",
        "メ" => "me",
        "モ" => "mo",
        "ヤ" => "ya",
        "ユ" => "yu",
        "ヨ" => "yo",
        "ラ" => "ra",
        "リ" => "ri",
        "ル" => "ru",
        "レ" => "re",
        "ロ" => "ro",
        "ワ" => "wa",
        "ヲ" => "wo",
        "ガ" => "ga",
        "ギ" => "gi",
        "グ" => "gu",
        "ゲ" => "ge",
        "ゴ" => "go",
        "ザ" => "za",
        "ジ" => "zi",
        "ズ" => "zu",
        "ゼ" => "ze",
        "ゾ" => "zo",
        "ダ" => "da",
        "ヂ" => "di",
        "ヅ" => "du",
        "デ" => "de",
        "ド" => "do",
        "バ" => "ba",
        "ビ" => "bi",
        "ブ" => "bu",
        "ベ" => "be",
        "ボ" => "bo",
        "パ" => "pa",
        "ピ" => "pi",
        "プ" => "pu",
        "ペ" => "pe",
        "ポ" => "po",
        "ア" => "a",
        "イ" => "i",
        "ウ" => "u",
        "エ" => "e",
        "オ" => "o",
        "ン" => "#",
        "ッ" => "*",
      }.each do |key, value|
        term = term.to_s.gsub(Regexp.new(key), value)
      end
      term
    end

    def replace_consonant(romanized_term)
      romanized_term.gsub(/[bcdfghjklmnpqrstvwxyz]/, "x")
    end

    def extract_vowel(romanized_term)
      romanized_term.gsub(/[bcdfghjklmnpqrstvwxyz]/, "")
    end

    def vibes(a, b)
      score = 0

      a = replace_consonant(a)
      b = replace_consonant(b)

      if extract_vowel(a).length < 3 || extract_vowel(b).length < 3
        return 0
      end

      if a[-2..-1] != b[-2..-1]
        return 0
      end

      if a[-4..-1] == b[-4..-1]
        score = score + 2
      end

      if a[-5..-1] == b[-5..-1]
        score = score + 4
      end

      if a[-6..-1] == b[-6..-1]
        score = score + 6
      end

      if extract_vowel(a) == extract_vowel(b)
        score = score + 8
      end

      score
    end
  end
end
