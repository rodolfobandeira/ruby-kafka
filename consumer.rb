require 'kafka'

kafka = Kafka.new(seed_brokers: ['localhost:9092'])

#kafka.each_message(topic: 'greetings') do |message|

consumer = kafka.consumer(
  group_id: 'my-consumer',

  # Increase offset commit frequency to once every 5 seconds.
  offset_commit_interval: 5,

  # Commit offsets when 100 messages have been processed.
  offset_commit_threshold: 100,

  # Increase the length of time that committed offsets are kept.
  offset_retention_time: 7 * 60 * 60
)

consumer.subscribe('greetings')

trap("TERM") { consumer.stop }

consumer.each_message(automatically_mark_as_processed: false) do |message|
  puts message.offset, message.key, message.value

  consumer.mark_message_as_processed(message)
end

