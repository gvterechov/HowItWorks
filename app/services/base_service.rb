class BaseService
  attr_reader :host, :port

  class ServiceNotAvailableException < StandardError
  end

  def available?
    begin
      Net::HTTP.new(@host, @port).head('/').
        then { |result| result.kind_of?(Net::HTTPOK) || result.kind_of?(Net::HTTPNotFound) }
    rescue
      false
    end
  end
end
