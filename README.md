# DERP-AIO

DERP-AIO 是一个集成了 DERP (Designated Encrypted Relay for Packets) 服务器和 Tailscale 客户端的一体化解决方案。这个项目旨在简化 DERP 服务器的部署和管理过程，为 Tailscale 网络提供可靠的中继服务。

## 功能特性

- 🚀 一键部署 DERP 服务器
- 🔒 支持 SSL/TLS 加密
- 🔄 集成 Tailscale 客户端
- 📊 完整的日志记录
- 🛠 Docker 容器化部署
- ⚡ 高性能网络中继

## 快速开始

### 前置条件

- Docker 和 Docker Compose
- 域名及其SSL证书
- 基本的网络知识

### 安装步骤

1. 克隆仓库：
```bash
git clone https://github.com/xubiaolin/derp-aio.git
cd derp-aio
```

2. 配置环境变量：
```bash
cp .env-example .env
```
编辑 `.env` 文件，设置必要的环境变量。

3. 准备SSL证书：
将您的SSL证书文件放置在 `certs` 目录下：
- `your-domain.key` - SSL私钥
- `your-domain.crt` - SSL证书

4. 启动服务：
```bash
docker-compose up -d
```

## 配置说明

### 环境变量

主要的环境变量包括：
- `DERP_DOMAIN`: DERP服务器域名
- `DERP_ADDR`: DERP服务器监听地址
- `DERP_STUN_PORT`: STUN服务端口
- `CERT_PATH`: SSL证书路径

### 目录结构

```
.
├── certs/                 # SSL证书目录
├── supervisor/            # Supervisor配置
├── ts_data/              # Tailscale数据
├── derp_data/            # DERP服务器数据
├── log/                  # 日志目录
├── docker-compose.yml    # Docker编排配置
├── Dockerfile            # Docker构建文件
└── .env-example          # 环境变量示例
```

## 日志查看

日志文件位于 `log` 目录下：
- `log/derper/` - DERP服务器日志
- `log/tailscaled/` - Tailscale守护进程日志

## 贡献指南

欢迎提交 Issue 和 Pull Request！

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 支持

如果您在使用过程中遇到任何问题，请创建 Issue 或通过以下方式联系我们：

- GitHub Issues
- 电子邮件：[your-email@example.com]

## 致谢

感谢所有为本项目做出贡献的开发者！ 