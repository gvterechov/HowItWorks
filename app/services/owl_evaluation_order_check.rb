class OwlEvaluationOrderCheck < BaseService
  def initialize
    @host = 'localhost'
    @port = 8000
  end

  def verify_expression(expression = nil)
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{host}:#{port}/api/check")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json, 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end

  def get_supplement(expression = nil)
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{host}:#{port}/api/check")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json, 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end

  def available_syntaxes
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{host}:#{port}/api/check")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, { action: :supported_task_languages }.to_json, 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end
end
