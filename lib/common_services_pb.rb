# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: common.proto for package 'com.gpch.grpc.protobuf'

require 'grpc'
require 'common_pb'

module Com
  module Gpch
    module Grpc
      module Protobuf
        module SentenceCheckerService
          class Service

            include ::GRPC::GenericService

            self.marshal_class_method = :encode
            self.unmarshal_class_method = :decode
            self.service_name = 'com.gpch.grpc.protobuf.SentenceCheckerService'

            rpc :ValidateTokenPosition, ::Com::Gpch::Grpc::Protobuf::ValidateTokenPositionRequest, ::Com::Gpch::Grpc::Protobuf::ValidateTokenPositionResponse
            rpc :GetTaskSetup, ::Com::Gpch::Grpc::Protobuf::GetTaskSetupRequest, ::Com::Gpch::Grpc::Protobuf::GetTaskSetupResponse
          end

          Stub = Service.rpc_stub_class
        end
      end
    end
  end
end