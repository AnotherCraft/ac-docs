# Compiling stuff for client
```
git clone -b RELEASE_TAG_HERE https://github.com/grpc/grpc
cd grpc
git submodule update --init
mkdir .build
cd .build
cmake ../
(build in msvc)
```

1. Edit the `gen_client.bat`, set `PROTOC` to path to protoc that you've built
1. Edit the `gen_client.bat`, set `GRPC_FOLDER` to your gprc build folder
1. Call `./gen_client.bat`