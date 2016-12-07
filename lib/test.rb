module Test
  def send_msg(msg, user_key = "1")
    uri = URI("http://localhost:3000/message")
    req = Net::HTTP::Post.new(uri)
    req.add_field 'Content-Type', 'application/json'
    req.body = {
      user_key: user_key,
      type: "text",
      content: msg
    }.to_json
    Net::HTTP.start(uri.host, uri.port) do |http|
      rsp = http.request(req)
      puts rsp
      JSON.parse(rsp.body)
    end
  end
end
