# Hysteria-in-docker

将hysteria + udp2raw 放到docker里面运行

> [!IMPORTANT]  
> 客户端和服务端分别仅在**最新Arch Linux**和**Ubuntu 24.04 Server**下测试可用.
> 
> 理论上能装docker的较新Linux都能用, darwin 通过指定`--platform`也能运行，但Windows有可能无法正常运行. （darwin和Windows未进行任何测试）

## 运行

1. 服务端
   
   ```
   docker run --privileged -p 8090:8090 -d lry127/hysteria_server
   ```

2. 客户端
   
   ```
   docker run --privileged --network host -d -e SERVER_IP=1.1.1.1 -e SERVER_PORT=8090 lry127/hysteria_client
   ```
   
   将`1.1.1.1`改成你的服务器ip即可（仅支持ip地址，不能用域名）
   
   此命令将监听本地 1080 端口（默认配置情况下）。

## 客户端配置

运行客户端时，可以将其余客户端配置挂载到`/client/extra.yaml` 以微调客户端。运行docker时指定`-v /path/to/my/custom/extra.yaml:/client/extra.yaml` 即可。

> [!CAUTION]
> 
> 所有自定义文件都必须至少包含源码中`client_extra.yaml` 的条目，否则hysteria会运行异常。（已经存在于`client-template.yaml`中的也不得修改）

默认配置为:

```
bandwidth: 
  up: 10 mbps
  down: 10 mbps

socks5:
  listen: 127.0.0.1:1080 

http:
  listen: 127.0.0.1:8080
```

## 构建

请确保以下命令存在PATH中：`docker openssl wget pwgen`

```
./build.sh
```

命令完成后会在`build-tmp`录中生成`server.img`和`client.img`

需要执行`docker image load -i xxx.img`将镜像导入docker

> [!TIP]
> 也可以通过修改`build.sh` 中的`server_image_output` 和`client_image_output`来修改镜像名字，然后用`docker push xxx` 方便地推到registry.

## License

1. [hysteria](https://github.com/apernet/hysteria/blob/master/LICENSE.md)

2. [udp2raw](https://github.com/wangyu-/udp2raw/blob/unified/LICENSE.md)

[本项目许可证](https://github.com/lry127/hysteria-in-docker/blob/master/LICENSE)
