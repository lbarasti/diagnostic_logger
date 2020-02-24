class DiagnosticLogger
  module ChannelUtil
    def self.every(t : Time::Span, name = nil, terminate = Channel(Time).new, &block : -> T) : Channel(T) forall T
      Channel(T).new.tap { |values|
        spawn(name: name) do
          loop do
            select
            when timeout(t)
              values.send block.call
            when time = terminate.receive
              break
            end
          rescue Channel::ClosedError
            break
          end
        ensure
          values.close()
        end
      }
    end

    # Sends batches of messages either every `size` messages received or every `interval`,
    # if a batch has not been sent within the last `interval`.
    def self.batch(in_stream : Channel(T), size : Int32, interval : Time::Span) : Channel(Enumerable(T)) forall T
      # TODO: assert on `size` and `interval`
      Channel(Enumerable(T)).new.tap { |out_stream|
        memory = Array(T).new(size)
        tick = every(interval) { nil }
        sent = false
        spawn do
          loop do
            select
            when v = in_stream.receive
              memory << v
              if memory.size >= size
                out_stream.send(memory.dup)
                memory.clear
                sent = true
              end
            when tick.receive
              unless sent
                out_stream.send(memory.dup)
                memory.clear
              end
              sent = false
            end
          end
        rescue Channel::ClosedError
          out_stream.send(memory.dup)
          out_stream.close
        end
      }
    end
  end
end
