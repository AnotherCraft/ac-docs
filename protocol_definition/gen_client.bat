set GRPC_FOLDER="D:\Tvorba\Qt\libs\grpc\grpc\.build\Release"

"../../etc/protoc/bin/protoc.exe" --cpp_out="../../client/src/client/multiplayer/protocol" *.proto
rem "../../etc/protoc/bin/protoc.exe" --grpc_out="../../client/src/client/multiplayer/protocol" --plugin="protoc-gen-grpc=grpc_cpp_plugin" *.proto

"../../etc/protoc/bin/protoc.exe" --grpc_out="../../client/src/client/multiplayer/protocol" --plugin=protoc-gen-grpc="%GRPC_FOLDER%\grpc_cpp_plugin.exe" *.proto