require 'highline/import'
require 'launchy'

HighLine.track_eof = false

class F::Prompt

  @@commands = {
    'f' => [ 'follow link',
             lambda { |r| Launchy.open(r.url) } ]
  }

  def initialize(results)
    @results = results
    show
  end

  def show
    @results.each_with_index do |r, i|
      print with_padding("#{i.succ}.")
      puts r
    end

    loop do
      break if run_command(ask('> '))
    end
  end

  protected

  def run_command(s)
    command, args = parse_command_string(s)
    return help unless command
    command = command[1]
    return not_enough_arguments(command, args) if args.size < command.arity
    command.call(*args) || true
  end

  def parse_command_string(s)
    t = s.strip.split(/\s/)
    args = Array(t[1..-1])
    args[0] = @results[args[0].to_i-1] if args[0].to_s =~ /\A\d+\z/
    [@@commands[t[0]], args]
  end

  def with_padding(index)
    index.ljust(@results.size.to_s.length + 2)
  end

  def help
    puts 'Available commands: '
    puts @@commands.map { |a,c| "#{a} - #{c[0]}" }.join("\n")
  end

  def not_enough_arguments(c, a)
    puts "not enough arguments (#{a.size} for #{c.arity})"
  end

end
