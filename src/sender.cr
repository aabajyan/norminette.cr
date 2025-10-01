require "amqp-client"
require "uuid"

class Norminette::Sender
  @sender : AMQP::Client::Connection
  @channel : AMQP::Client::Channel
  @exchange : AMQP::Client::Exchange
  @queue : AMQP::Client::Queue
  @properties : AMQ::Protocol::Properties
  @counter : UInt32

  def initialize(callback : Proc(JSON::Any, Nil))
    @sender = AMQP::Client.new(host: HOSTNAME, user: USER, password: PASSWORD).connect
    @channel = @sender.channel
    @exchange = @channel.default_exchange
    @queue = @channel.queue
    @properties = AMQ::Protocol::Properties.new(reply_to: @queue.name, correlation_id: UUID.random.to_s)
    @counter = 0

    @queue.subscribe do |msg|
      @counter -= 1
      data = JSON.parse(msg.body_io)
      callback.call data
      if data["stop"]? == true
        @counter = 0
        close
      end
    end
  end

  def sync
    # TODO: Replace this loop with Thread::Mutex Thread::ConditionVariable
    # I've tried to use those Functions but ConditionVariable.signal wasn't
    # being called.
    until @counter == 0
      sleep 1.second
    end
  end

  def close
    @channel.close if @channel
    @sender.close if @sender
  end

  def publish(message : String)
    @counter += 1
    @exchange.publish(message, routing_key: ROUTING_KEY, props: @properties)
  end
end
