# RaspberryPi-Repo

Raspberry Pi学習・調査用のリポジトリ

## セットアップ手順

- ラズパイを組み立てる
- Raspberry Pi Imagerをダウンロードする
- 使用するラズベリーパイOSの決定する
- 64bitのラズパイOSが良い
  - https://www.raspberrypi.com/software/operating-systems/
  - Raspberry Pi OS (64-bit)
- microSDカードを差し込んでカードにOSの情報を書き込む
- ラズベリーパイOSのインストールは完了する
- microSDカードのラズパイへのセットする
- ラズパイにデスクトップとマウスを接続する
- 言語設定を行う
- ユーザー名とパスワードを確認する
- wifi接続の設定を行う

## RaspberryPiにカンタンSSH接続

- セキュリティ対策のためポート番号を変更する
  ```bash
  cd /boot
  sudo mkdir ssh 
  ```

  ```bash
  sudo nano /etc/ssh/sshd_config
  ```

  開かれたファイルの上の方にある`#Port 22`の部分を`Port 新ポート番号`に変更し、（コメントアウトを外すのを忘れずに）

  ```bash
  sudo /etc/init.d/ssh restart
  ```

  でSSHを実行し、

  ```bash
  ssh [新ユーザ名]@[RaspberryPiのIPアドレス] -p [新ポート番号]
  ```

  もしくは以下のコマンドが有効な場合

  ```bash
  ping raspberrypi.local        
  ```

  以下でも接続が可能

  ```bash
  ssh [新ユーザ名]@raspberrypi.local  -p [新ポート番号]
  ```

- aspberryPiのIPアドレス確認
  ```bash
  ifconfig
  ```
  もしくはラズパイ側で

  ```bas
  ip addr
  ```

- `wlan0: flags=  <UP,BROADCAST,RUNNING,MULTICAST>  mtu`の欄を確認し、ラズパイのIPアドレスを確認する
- IPアドレスを確認したらSSHコマンドで接続
  ```bash
  ssh
  ```

- よりセキュアに接続するために公開鍵を設定

  - 接続元の端末にて以下のコマンドを実施

    ```bash
    ssh-keygen -t rsa -b 4096 -C "email@example.com"
    ```

  - ラズパイ側で以下のコマンドを実行

    ```bash
    mkdir ~/.ssh
    ```

  - PC側で以下のコマンドを実行し、公開鍵認証に必要な鍵情報を送信

    ```bash
    cd [公開鍵の場所 (デフォルトではC:\Users\[ユーザ名]/.ssh)]
    scp -P [新ポート番号] id_rsa.pub [新ユーザ名]@[RaspberryPiのIPアドレス]:/home/[新ユーザ名]/.ssh
    ```

    実施後にラズパイ側に公開鍵が転送されていればOK!

  - 公開鍵のパーミッション変更

    ```bash
    cd ~/.ssh/
    cat id_rsa.pub >> authorized_keys
    chmod 600 authorized_keys
    chmod 700 ~/.ssh
    ```

    そして公開鍵を削除

    ```bash
    rm ~/.ssh/id_rsa.pub
    ```

## その他便利コマンド

- 要領確認

  ```bash
  df -h
  ```

- 再起動コマンド

  ```bash
  sudo reboot
  ```

## 参考文献

- [【2026年完全版】ラズベリーパイのOSインストールと初期設定｜Raspberry Pi 5対応](https://raspi-school.com/getting-started-with-raspberrypi/)
- [Using OpenClaw on Raspberry Pi](https://www.youtube.com/watch?v=BFHu3RFfLm0&t=2s)
- [Turn your Raspberry Pi into an AI agent with OpenClaw](https://www.raspberrypi.com/news/turn-your-raspberry-pi-into-an-ai-agent-with-openclaw/)
- [最近話題の OpenClaw（旧：Clawdbot/Moltbot）をラズパイ 5 で動かしてみた](https://zenn.dev/edom18/articles/try-clawdbot-on-raspi)
- [ラズパイの公式サイト](https://www.raspberrypi.com/software/)
- [Raspberry Pi Imagerのダウンロード](https://www.raspberrypi.com/software/)
- [Raspberry Pi OS](https://www.raspberrypi.com/software/operating-systems/)
- [VSCodeでssh接続してRaspberry Piを触りたい](https://tec.tecotec.co.jp/entry/2021/12/11/000000)
- [買ったらまず実施！RaspberryPiのセキュリティ対策](https://qiita.com/c60evaporator/items/ebe9c6e8a445fed859dc)