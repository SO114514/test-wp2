# ベースイメージとして UBI 9 を使用
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

# 必要なツールをインストール
RUN microdnf install -y php php-mysqlnd php-gd php-xml tar wget shadow-utils \
    && microdnf clean all

# 非ルートユーザー usr 1001 を作成
RUN useradd -u 1001 -r -g 0 -d /opt/app-root/src -s /sbin/nologin -c "Default Application User" default && \
    mkdir -p /opt/app-root/src && \
    chown -R 1001:0 /opt/app-root/src && \
    chmod -R ug+rwX /opt/app-root/src

# WordPress をダウンロードして配置
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz -C /opt/app-root/src && \
    mv /opt/app-root/src/wordpress /opt/app-root/src/html && \
    chown -R 1001:0 /opt/app-root/src/html && \
    chmod -R ug+rwX /opt/app-root/src/html

# WordPress を設置するディレクトリを作業ディレクトリに設定
WORKDIR /opt/app-root/src/html

# ポート公開
EXPOSE 8080

# 非ルートユーザーで実行
USER 1001

# 起動コマンド
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/opt/app-root/src/html"]
