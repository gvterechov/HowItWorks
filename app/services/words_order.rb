# grpc_tools_ruby_protoc -I ./protos --ruby_out=lib --grpc_out=lib ./protos/common.proto
require_relative '../../lib/common_pb.rb'
require_relative '../../lib/common_services_pb.rb'

class WordsOrder < BaseService # TODO BaseGrpcService
  AVAILABLE_LANGUAGES = {
    en: Com::Gpch::Grpc::Protobuf::Language::EN,
    ru: Com::Gpch::Grpc::Protobuf::Language::RU
  }.freeze

  def initialize
    @host = 'localhost'
    @port = 8081
  end

  def verify(expression)
    raise ServiceNotAvailableException.new unless available?

    response = stub.validate_token_position(Com::Gpch::Grpc::Protobuf::ValidateTokenPositionRequest.new(expression))
    response_to_hash(response)
  end

  def available?
    response = stub.validate_token_position(Com::Gpch::Grpc::Protobuf::ValidateTokenPositionRequest.new(empty_task))
    response.present?
  rescue
    return false
  end

  private
    def response_to_hash(response)
      result = {}
      result[:studentAnswer] = []
      response.studentAnswer.each do |answer|
        result[:studentAnswer] << {
          id: answer.id,
          name: answer.name,
        }
      end
      result[:wordsToSelect] = response.wordsToSelect
      result[:errors] = []

      response.errors.each do |error|
        parts = error.error.map do |part|
          {
            text: part.text,
            type: part.type
          }
        end

        result[:errors] << parts if parts.present?
      end
      result.with_indifferent_access
    end

    def stub
      Com::Gpch::Grpc::Protobuf::SentenceCheckerService::Stub
        .new("#{host}:#{port}", :this_channel_is_insecure)
    end

    def empty_task
      {
        "lang": AVAILABLE_LANGUAGES[:en],
        "studentAnswer": [],
        "wordsToSelect": [],
        "taskInTTLFormat": ""
      }
    end
end
