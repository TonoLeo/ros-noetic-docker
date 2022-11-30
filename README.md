# ros-noetic-image

## パッケージの概要
Docker内でGUIを使用できるROS NoeticのImageを作成するパッケージ。

## Dockerのインストール
```
$ sudo apt-get install docker.io
```
## 本パッケージのインストール
```
$ git clone  https://github.com/TonoLeo/ros-noetic-image.git
```
## Docker Imageの作成
```
$ cd ros-netic-image 
$ sudo docker build -t <image_name>:<TAG> -f Dockerfile .
```
## コンテナの作成と起動

### 作成したDocker ImageのIMAGE IDの取得 
```
$ sudo docker ps
```
### 作成と起動
```
$ xhost local:<IMAGE ID>
$ sudo docker run -it --gpus all --privileged  --net=host --ipc=host --env="DISPLAY=$DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --env="XAUTHORITY=$XAUTH" --volume="$XAUTH:$XAUTH" --runtime=nvidia <image_name>:<TAG>
```

---
## 動作環境

- Docker 20.10.12
- Ubuntu 22.04 LTS
---
## LICENSE

[Apache License 2.0](https://github.com/TonoLeo/ros-noetic-image/blob/master/LICENSE)
