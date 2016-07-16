describe Rhymer::Lyric do
  let(:text) { '今日はとても良い天気ですね。' }
  let(:lyric) { described_class.new(text) }

  describe '.new' do
    context 'given text' do
      subject { lyric }
      it { is_expected.to be_instance_of described_class }
      it { is_expected.to respond_to(:lyric) }
      it { is_expected.not_to respond_to(:lyric=) }
    end

    context 'given nil text' do
      let(:text) { nil }

      subject { -> { lyric } }
      it { is_expected.to raise_error(ArgumentError, 'Text to parse cannot be nil') }
    end
  end

  describe '#lyric' do
    subject { lyric.lyric }
    it { is_expected.to include an_instance_of(Natto::MeCabNode) }
  end

  describe '#mecab' do
    subject { lyric.mecab }
    it { is_expected.to be_instance_of Natto::MeCab }
  end

  describe '#nouns' do
    let(:nouns) do
      {
        0 => an_instance_of(Natto::MeCabNode),
        4 => an_instance_of(Natto::MeCabNode)
      }
    end

    subject { lyric.nouns }
    it { is_expected.to include nouns }

    describe '#[0]' do
      describe '#feature' do
        subject { lyric.nouns[0].feature }
        it { is_expected.to match /\A名詞/ }
      end
    end
  end
end
