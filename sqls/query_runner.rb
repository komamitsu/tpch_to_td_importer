require 'time'
require 'pp'

class QueryRunner
  def initialize(apikey, database, type, count = 4)
    @apikey = apikey
    @database = database
    @type = type
    @count = count
  end

  def run(sqls)
    result = {}
    @count.times do |i|
      sqls.each do |sql|
        result[sql] ||= []
        output = `td -k #{@apikey} query -T #{@type} -d #{@database} -w -q #{sql} 2>&1`
        # Job 5613702 is queued.
        # Use 'td job:show 5613702' to show the status.
        # queued...
        # started at 2013-11-03T14:23:05Z
        # executing query: select count(1) from lineitem where time >= 912470400 - 3600 * 24 * 7 and time < 912470400
        # finished at 2013-11-03T14:23:06Z
        # Status     : success
        info = {}
        output.each_line do |l|
          puts l
          info[:detail] ||= ''
          info[:detail] << l
          case l
          when /Job (\d+) is queued/
            info[:job_id] = Integer($1)
          when /started at ([\w\-:]+)/
            info[:started_at] = Time.parse($1)
          when /finished at ([\w\-:]+)/
            info[:finished_at] = Time.parse($1)
          when /Status\s*:\s*(\w+)/
            info[:status] = $1
          end
        end
        result[sql] << info
      end
    end
    result
  end
end

if $0 == __FILE__
  apikey = ARGV.shift
  database = ARGV.shift
  type = ARGV.shift
  sqls = ARGV
  raise "usage: #{$0} apikey database type sqls" unless apikey && database && type

  module Enumerable
    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end
  end 

  runner = QueryRunner.new(apikey, database, type)
  results = runner.run(sqls)
  results.each_pair do |kv|
    sql, tests = *kv
    durations = []
    tests.each do |info|
      next unless info[:status] == 'success'
      durations << (info[:finished_at].to_i - info[:started_at].to_i)
    end
    puts <<EOS
-------------------------------------------------------------
#{sql}

Durations(seconds): #{durations.map{|x| x.to_s}.join(', ')}
Average(seconds):   #{durations.mean}
Std dev(seconds):   #{durations.standard_deviation}

EOS
  end
  puts "-------------------------------------------------------------"

  pp results
end

