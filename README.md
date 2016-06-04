# Rhymer

与えられた文章の中から韻を踏んでいるフレーズの組み合わせを見つけ出すライブラリです。

## Installation

リポジトリをクローンします。

```
git clone https://github.com/suzuki86/rhymer.git
```

クローンしたディレクトリに移動します。

```
cd rhymer
```

必要なgemをインストールします。

```
bundle install
```

Gemをビルドします。

```
gem build rhymer.gemspec
```

インストールします。

```
gem install rhymer-x.x.x.gem
```

## Dependencies

`natto`、`thor`が利用できる必要があります。


## Usage

`Rhymer::Parser.new`の引数に文章を渡すと、検査結果が含まれたインスタンスが生成されます。インスタンスの`rhymes`メソッドを実行すると、韻を踏んでいるフレーズの組み合わせの配列が返されます。

```
require "rhymer"

rhymer = Rhymer::Parser.new("今日はとても良い天気ですね。こんな日は自然に元気になります。")
rhymer.rhymes.each do |rhyme|
  puts [rhyme[0], rhyme[1]].join(" ")
end
```

上記のコードを実行すると下記の結果が出力されます。

```
今日は良い天気 こんな日は自然に元気
```

### CLI

コマンドラインからも実行できます。

```
rhymer spit 今日はとても良い天気ですね。こんな日は自然に元気になります。
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/suzuki86/rhymer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

