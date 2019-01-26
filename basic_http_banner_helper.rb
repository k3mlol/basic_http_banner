#!/usr/bin/env ruby

class ThreadPool
    def initialize(max_threads = 10)
      @pool = SizedQueue.new(max_threads)
      max_threads.times{ @pool << 1 }
      @mutex = Mutex.new
      @running_threads = []
    end
  
    def run(&block)
      @pool.pop
      @mutex.synchronize do
        @running_threads << Thread.start do
          begin
            block[]
          rescue Exception => e
            puts "Exception: #{e.message}\n#{e.backtrace}"
          ensure
            @pool << 1
          end
        end
      end
    end
  
    def await_completion
      @running_threads.each &:join
    end
  end