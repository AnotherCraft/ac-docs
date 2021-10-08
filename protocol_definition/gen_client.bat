set GRPC_FOLDER="D:\Tvorba\Qt\libs\grpc\grpc\.build\Release"
set PROTOC="D:\Tvorba\Qt\libs\grpc\grpc\.build\third_party\protobuf\Release\protoc.exe"

%PROTOC% --cpp_out="../../client/src/common/multiplayer/protocol" *.proto
%PROTOC% --grpc_out="../../client/src/common/multiplayer/protocol" --plugin=protoc-gen-grpc="%GRPC_FOLDER%\grpc_cpp_plugin.exe" *.proto