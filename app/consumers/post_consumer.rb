class PostConsumer < Racecar::Consumer
  subscribes_to "posts"

  def process(message)
    data = JSON.parse(message.value)
    puts "-- Processed Message --"
    puts data.inspect
    puts Post.all.inspect
    puts "-----------------------"
    sleep 1
    raise StandardError.new("Do NOT commit")
  end
end
