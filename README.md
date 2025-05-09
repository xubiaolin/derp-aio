# DERP-AIO

DERP-AIO 是一个集成了 DERP (Designated Encrypted Relay for Packets) 服务器和 Tailscale 客户端的一体化解决方案。这个项目旨在简化 DERP 服务器的部署和管理过程，为 Tailscale 网络提供可靠的中继服务。

## 功能特性

- 🚀 一键部署 DERP 服务器
- 🔒 支持 SSL/TLS 加密
- 🔄 集成 Tailscale 客户端
- 📊 完整的日志记录
- 🛠 Docker 容器化部署

## 快速开始
### 前置条件
- Docker和一个AMD64架构的设备
- 一个域名以及SSL证书
- 基本的Linux命令行操作能力

### 下载仓库代码：
```bash
git clone https://github.com/xubiaolin/derp-aio.git
cd derp-aio
```

配置环境变量：
```bash
cp .env-example .env
```

编辑 `.env` 文件，设置必要的环境变量。

**目前只支持域名证书**，域名证书的名字规则如下：

假设你的域名是：`you-domain.com`

证书私钥名字就是：`you-domain.com.key`

证书公钥名字就是：`you-domain.com.crt`

证书私钥和证书公钥需要放在 `你设置的证书路径` 目录下，同时在.env文件中设置 `CERT_PATH` 变量，例如：./certs

如果你使用的软链接，那么注意要使用绝对路径，例如：
```bash
ln -s /path/to/your/certs $(pwd)/certs
```

### 启动服务：

docker compose 启动：
```bash
docker compose up -d
```

docker run 启动：
```bash
docker run -d \
 --name derp-aio \
 -v $(pwd)/certs:/app/certs \
 -v $(pwd)/log:/app/log \
 --env-file .env \
 xubiaolin/derp-aio:latest
```

### 检查服务是否部署成功
浏览器访问：`https://your-domain.com:{DERP_ADDR}`，这个DERP_ADDR是你在.env文件中设置的DERP_ADDR变量，例如：https://derp.your-domain.com:18443

如果看到DERP-AIO的页面，说明服务部署成功。

![Derp成功页面](https://cdn.jsdelivr.net/gh/xubiaolin/picgo@master/34ff5065a0387b9b5b3377d9b1e80c74818ae2642913e8f4f542ec07094e3520.png)  


## 配置Tailscale
### 配置derpMap
将下面的内容替换为你真实的内容：
```json
    "derpMap": {
        "OmitDefaultRegions": false,
        "Regions": {
            "900": {
                "RegionID": 900,
                "RegionCode": "CN-BJ",
                "RegionName": "北京",
                "Nodes": [
                    {
                        "Name": "BJ-1",
                        "RegionID": 900,
                        "HostName": "your-domain.com",//这个是你env文件中设置的DERP_DOMAIN变量
                        "DERPPort": 18443,//这个是你env文件中设置的DERP_ADDR变量
                        // "IPv4": "你的ip,这个可以不写",
                        "STUNPort": 3478,//这个是你env文件中设置的DERP_STUN_PORT变量
                    }
                ]
            }
        }
    }
```

登录tailscale官方后台：进入Access Controls:
![picture 1](https://cdn.jsdelivr.net/gh/xubiaolin/picgo@master/1f901668009a45de5d12312acdd7346edf9d9e98923527b4fa5d8d26bbad2380.png)  

将上面的内容修改后，粘贴到如下位置：
![picture 2](https://cdn.jsdelivr.net/gh/xubiaolin/picgo@master/b8578d88a9a46457c736f939461e9854fc188d55ebfda226b98734b510176367.png)  

然后点击保存即可

### 配置DERP_VERIFY_CLIENTS[可选]
如果.env文件中设置的DERP_VERIFY_CLIENTS变量为true,那么需要执行该步骤，否则跳过。

在服务器上执行命令：
```bash
docker exec -it derp-aio tailscale up 
```

然后有类似输出：
![picture 3](https://cdn.jsdelivr.net/gh/xubiaolin/picgo@master/09b56c4cfd236d274adf9e44a2e5886025ea318b3a6f5c9c710626ec10aa1862.png)  

点击这个链接，进行授权即可。

### 检查是否成功：
客户端执行命令：
```bash
tailscale netcheck
```

如果看到类似输出：
![picture 4](https://cdn.jsdelivr.net/gh/xubiaolin/picgo@master/56b7985b427b6f9c8630f0b8f3b08501730318c79fb7a5d83acb34417409ce91.png)  

并且执行命令：
```bash
tailscale status
```
没有错误，说明DERP-AIO部署成功。

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

## 致谢

感谢所有为本项目做出贡献的开发者！ 
