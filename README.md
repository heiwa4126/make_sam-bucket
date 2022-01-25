# make_sam-bucket

`sam build` しといたプロジェクトフォルダ全部をzipして
他所へ持っていって
`sam deply` しようとすると、
SAM用のS3バケットがあったりなかったりしてうまくいかない。
`sam deply --guided`だとOKなのだが、これは対話的で自動化がめんどう。

そこで

1. (そのリージョンの) aws-sam-cli-managed-defaultsスタックがあれば、それからS3バケット名を得る
2. スタックがなければ作って、それからS3バケット名を得る
3. samconfig.tomlの s3_bucket="..."を書き換える。

という手順で解決しよう、と考えて書いたコード。

だがしかし、もう少しかんたんな解決法が見つかった。


# 実際に使った手法

非対話にしたい場合は、

1. samconfig.tomlからs3_bucket="..."を取り除いて
2. `sam deploy --resolve-s3`

でいける。`aws-sam-cli-managed-default` stackも(つまりSAM用S3バケットも)つくってくれる。

ただし、この手法だとsamconfig.tomlにバケット名を書き戻してくれないので、
- 毎回 `--resolve-s3` つきでdeploy
- または手でsamconfig.tomlに書き込む
- または1回だけ`sam deploy --guided` (samconfig.tomlを更新してくれる)

のいずれかを実行すること。
