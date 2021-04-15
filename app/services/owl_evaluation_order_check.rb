class OwlEvaluationOrderCheck
  def self.call(expression = nil)
    uri = URI.parse("http://localhost:8000/api/check")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json, 'Content-Type': 'application/json')
    JSON.load(response.body)&.with_indifferent_access
  end
end
