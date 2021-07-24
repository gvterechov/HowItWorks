class COwl < BaseService
  def initialize
    @host = 'localhost'
    @port = 2020
  end

  def creating_task(expression = nil)
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{@host}:#{@port}/creating_task")
    http = Net::HTTP.new(uri.host, uri.port)
    # TODO удалить все id их xml
    response = http.post(uri, expression.to_json.gsub('\#', ''), 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end

  def verify_trace_act(expression = nil)
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{@host}:#{@port}/verify_trace_act")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json, 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end

  def available_syntaxes
    raise ServiceNotAvailableException.new unless available?

    uri = URI.parse("http://#{@host}:#{@port}/available_syntaxes")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri)
    JSON.load(response.body)&.with_indifferent_access
  end
end
