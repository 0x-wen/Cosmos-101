#!/usr/bin/env bash

set -eo pipefail

# get protoc executions
# go get github.com/regen-network/cosmos-proto/protoc-gen-gocosmos 2>/dev/null

# echo "Generating gogo proto code"
# cd proto
# proto_dirs=$(find ../proto -path -prune -o -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
# for dir in $proto_dirs; do
#   for file in $(find "${dir}" -maxdepth 1 -name '*.proto'); do
#     if grep go_package $file &>/dev/null; then
#       echo "Generating gogo proto code for $file"
#       buf generate --template buf.gen.gogo.yaml $file
#     fi
#   done
# done

# cd ..

# move proto files to the right places
#
# Note: Proto files are suffixed with the current binary version.
# cp -r github.com/GeaNetwork/gea/* ./

# rm -rf github.com

# TODO: Uncomment once ORM/Pulsar support is needed.
#
# Ref: https://github.com/osmosis-labs/osmosis/pull/1589

# echo "Generating Python proto code"
# mkdir -p python_proto_out
# proto_dirs=$(find ./proto -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
# for dir in $proto_dirs; do
#   for file in $(find "${dir}" -maxdepth 1 -name '*.proto'); do
#     if grep go_package $file &>/dev/null; then
#       echo "Generating Python proto code for $file"
#       python3 -m grpc_tools.protoc -I ./proto -I ../proto-depend --python_out=python_proto_out --grpc_python_out=python_proto_out $file
#     fi
#   done
# done

# 如果项目仅需要 Protobuf 消息序列化和反序列化功能，使用 --prost_out
# 如果项目需要实现 gRPC 通信（包括客户端和服务端逻辑），使用 --tonic_out
echo "Generating Rust proto code"
mkdir -p rust_proto_out
proto_dirs=$(find ./proto -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
for dir in $proto_dirs; do
  for file in $(find "${dir}" -maxdepth 1 -name '*.proto'); do
    if grep go_package $file &>/dev/null; then
      echo "Generating Rust proto code for $file"
      protoc --proto_path=./proto --proto_path=../proto-depend \
        --proto_path=../proto-depend \
        --plugin=protoc-gen-prost=$(which protoc-gen-prost) \
        --plugin=protoc-gen-tonic=$(which protoc-gen-tonic) \
        --prost_out=rust_proto_out \
        --tonic_out=rust_proto_out \
        $file
    fi
  done
done
