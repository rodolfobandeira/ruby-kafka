require 'kafka'
require 'securerandom'

kafka = Kafka.new(
  seed_brokers: ['127.0.0.1:9092'],
  client_id: 'my-application',
)

kafka.deliver_message("Hello, World! #{SecureRandom.uuid}", topic: 'greetings')

