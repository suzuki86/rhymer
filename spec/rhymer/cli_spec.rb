describe Rhymer::CLI do
  let(:cli) { described_class.new }

  describe '#spit' do
    context 'given text' do
      let(:text) { '今日はとても良い天気ですね。こんな日は自然に元気になります。' }

      subject { -> { cli.spit(text) } }
      it { is_expected.to output("今日は良い天気 こんな日は自然に元気\n").to_stdout }
    end
  end
end
