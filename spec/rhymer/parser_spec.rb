describe Rhymer::Parser do
  let(:text) { '今日はとても良い天気ですね。こんな日は自然に元気になります。' }
  let(:parser) { described_class.new(text) }

  describe '.new' do
    context 'given text' do
      subject { parser }
      it { is_expected.to be_instance_of described_class }
      it { is_expected.to respond_to(:lyric) }
      it { is_expected.not_to respond_to(:lyric=) }
      it { is_expected.to respond_to(:rhymes) }
      it { is_expected.not_to respond_to(:rhymes=) }
    end

    context 'given nil text' do
      let(:text) { nil }

      subject { -> { parser } }
      it { is_expected.to raise_error(NoMethodError, "undefined method `gsub' for nil:NilClass") }
    end
  end

  describe '#lyric' do
    subject { parser.lyric }
    it { is_expected.to be_instance_of Rhymer::Lyric }
  end

  describe '#rhymes' do
    subject { parser.rhymes }

    context 'with default config' do
      context 'given rhymed text' do
        it { is_expected.to eq [['今日は良い天気', 'こんな日は自然に元気', 20]] }
      end

      context 'given no rhymed text' do
        let(:text) { '今日はとても良い天気ですね。' }
        it { is_expected.to eq [] }
      end
    end

    context 'with custom config' do
      let(:parser) { described_class.new(text, config) }

      context 'given low config[:vibes_threshold]' do
        let(:config) { { vibes_threshold: 19, prefix_length: 4 } }
        it { is_expected.to eq [['今日は良い天気', 'こんな日は自然に元気', 20]] }
      end

      context 'given high config[:vibes_threshold]' do
        let(:config) { { vibes_threshold: 20, prefix_length: 4 } }
        it { is_expected.to eq [] }
      end

      context 'given config[:prefix_length]' do
        let(:config) { { vibes_threshold: 4, prefix_length: 0 } }
        it { is_expected.to eq [['良い天気', 'こんな日は自然に元気', 20]] }
      end
    end
  end
end
