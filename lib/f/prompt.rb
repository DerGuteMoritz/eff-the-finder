require 'highline/import'
require 'launchy'

HighLine.track_eof = false

class F::Prompt

  @@commands = {
    'f' => [ 'follow link',
             lambda { |r| Launchy.open(r.url) } ],

    's' => [ 'show results',
             :show ],

    'q' => [ 'quit',
             lambda { exit } ]
  }

  protected

  def initialize(results)
    @results = results
    show
    run
  end

  def show
    puts @results.header if @results.header

    @results.each_with_index do |r, i|
      print with_padding("#{i.succ}.")
      puts r
    end
  end

  def run
    loop { run_command(ask('> ')) }
  end

  def run_command(s)
    command, args = parse_command_string(s)
    return help unless command
    command = method(command) unless command.respond_to? :call
    return not_enough_arguments(command, args) if args.size < command.arity
    command.call(*args) || true
  end

  def parse_command_string(s)
    if s =~ /\A(\d+)\z/
      c = @@commands['f']
      args = [@results[$1.to_i-1]]
    else
      c = @@commands[s[/\A([a-z]+)/, 1]]
      args = Array(s[/\A[a-z]+(.*)/, 1].to_s.strip.split(/\s/))
      args[0] = @results[args[0].to_i-1] if args[0].to_s =~ /\A\d+\z/
    end

    [c && c[1], args]
  end

  def with_padding(index)
    index.ljust(@results.size.to_s.length + 2)
  end

  def help
    puts 'Available commands: '
    puts @@commands.sort_by { |c| c[0] }.map { |a,c| "#{a} - #{c[0]}" }.join("\n")
  end

  def not_enough_arguments(c, a)
    puts "not enough arguments (#{a.size} for #{c.arity})"
  end

end
