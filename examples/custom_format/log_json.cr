require "../../src/diagnostic_logger"

log = DiagnosticLogger.new("to-console")
done = Channel(Nil).new

spawn(name: "publisher") do
  5.times { |i|
    log.info("#{i} hello world")
    sleep rand
  }
  done.send nil
end

done.receive
