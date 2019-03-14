# MSS_Demo_Record_Plugin
[MelonSoda Server](https://www.melonsoda.tokyo/)で作成したサーバで録画するDEMOを日付ごとに保存するためのプラグインです。   

# How to setup
プラグインを利用するには`Metamod:Source`と`SourceMod`を導入する必要があります。  
Clone or DownloadからDownload ZIPをクリックしダウンロードします。   
ダウンロードしたファイルを解凍します。  
`addons/sourcemod`と`cfg`をサーバに保存します。  
以上でセットアップは完了です。  

# Note
`tv_enable "1"`にする必要があります。  
`tv_autorecord "0"`にする必要があります。 
上記の設定を行わない場合、プラグインによって強制的に書き換えられます。 
`sv_hibernate_when_empty "0"`の場合、サーバからプレイヤーがいなくなってもDEMO録画が継続されます。 

# Convars
Convarを変更して設定を変更することができます。 
変更する場合には`cfg`にある`mss_demo_record_plugin.cfg`を編集します。 
- `mss_demo_native_plugin`
- - Default: `1`
- - Description:
- - `MSS Match Plugin互換`
- - `MSS Match Pluginを利用している場合(1)は、試合開始時にDEMO録画開始`
- - `MSS Match Pluginを利用していない場合(0)は、マップ開始時にDEMO録画開始`
- - `MSS Match Pluginを利用している場合で、ウォームアップも録画対象にしたい場合は(0)を選択`
- `mss_demo_name`
- - Default: `auto-%Y%m%d-%H%M-<*MAPNAME*>`
- - Description:
- - `DEMOファイルの名前`
- - `DateTime形式`
- - `表示例: auto-20190315-1200-de_mirage`
- - `注意: .demはつけないこと`
- `mss_damo_directory`
- - Default: `demo_record/%Y-%m/%Y-%m-%d`
- - Description:
- - `DEMOファイルの名前`
- - `DateTime形式`
- - `保存先例: csgo/demo_record/2019_03/2019-03-15/`
- - `注意: csgoディレクトリ以下にのみ指定可能`
- `mss_demo_record_start_time`
- - Default: `5.0`
- - Description:
- - `DEMO録画が開始される時間`
- - `mss_demo_native_plugin "0"のときのみ有効`
- - `プレイヤーがサーバに接続したX秒後にDEMO録画開始`
- - `tv_delayの影響を受けるため低遅延を推奨`