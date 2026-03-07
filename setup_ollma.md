# Ollmaのセットアップメモ

## インストール

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

## unitファイルを編集

```txt
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/user/.local/bin:/home/user/bin"
Environment="OLLAMA_MODELS=/disk/hdd5/ollama-models"
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_ORIGINS=192.168.*,172.*"

[Install]
WantedBy=default.target
```

## モデルファイルのディレクトリを作成して権限設定する

```txt
ls -ld /usr/share/ollama/.ollama/models

mkdir -p /disk/hdd5/ollama-models
chmod 755 /disk/hdd5/ollama-models
chown ollama.ollama /disk/hdd5/ollama-models

ls -ld /disk/hdd5/ollama-models
```

```bash
su -s /bin/bash ollama
ls -ld /disk/hdd5/ollama-models
exit
```

Ollamaサービスを起動する

```bash
systemctl daemon-reload
systemctl start ollama
```

ollamaのポートを解放する

```bash

```

モデルのダウンロード

```bash
ollama pull phi3
```

モデル一覧を確認

```bash
ollama ls
```

モデルを実行

```bash
ollama run phi3
```