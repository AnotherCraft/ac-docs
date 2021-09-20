# Compiling stuff for client
1. Download protocol buffer compiler from https://github.com/protocolbuffers/protobuf/releases/latest and put it to `(AC root)/etc/protoc`
1. Edit the `gen_client.bat`, set `GRPC_FOLDER` to your gprc build folder
1. Call `./gen_client.bat`