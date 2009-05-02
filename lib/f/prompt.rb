require 'highline/import'
require 'launchy'

HighLine.track_eof = false

class F::Prompt

  class InvalidIndex < StandardError

    def initialize(index)
      super "`#{index}' is not a valid index."
    end

  end

  @@commands = {
    :f => [ 'follow link',
            lambda { |r| Launchy.open(r.url.to_s) },
            { :result_index => 0 } ],

    :o => [ 'pass selected result to given command (%u for URL, %n for name)',
            lambda { |r, *cmd|
              c = cmd.join(' ').gsub('%u', r.url.to_s).gsub('%n', r.name)
              raise ArgumentError, 'command string is required' if c =~ /\A\s*\z/
              system(c)
            },
            { :result_index => 0 } ],

    :l => [ 'list results',
            :list ],

    :n => [ 'next page',
            :next_page ],

    :p => [ 'previous page',
            :previous_page ],

    :q => [ 'quit',
            lambda { exit } ]
  }

  def self.define(name, command)
    @@commands[name.to_sym] = command
  end

  protected

  def initialize(results)
    @results = results
    list
    run
  end

  def list
    puts @results.header if @results.header

    @results.each_with_index do |r, i|
      print with_padding("#{i.succ}.")
      puts r
    end
  end

  def page(p)
    @results = @results.send("#{p}_page")
    list
  rescue F::Result::PageError
    puts "There is no #{p} page"
  end

  def next_page
    page(:next)
  end

  def previous_page
    page(:previous)
  end

  def run
    loop { run_command(ask('> ') { |q| q.readline = true } ) }
  end

  def run_command(s)
    command, args = parse_command_string(s)
    return help unless command
    command = method(command) unless command.respond_to? :call
    return not_enough_arguments(command, args) if args.size < command.arity
    command.call(*args) || true
  rescue => e
    puts "Error: #{e}"
  end

  def parse_command_string(s)
    if s =~ /\A(\d+)\z/
      c = @@commands[:f]
      args = [result_for_index($1)]
    else
      c = @@commands[s[/\A([a-z]+)/, 1].try(:to_sym)]
      args = Array(s[/\A[a-z]+(.*)/, 1].to_s.strip.split(/\s/))

      if c && c[2] && (i = c[2][:result_index])
        args[i] = result_for_index(args[i])
      end
    end

    [c && c[1], args]
  end

  def with_padding(index)
    index.ljust(@results.size.to_s.length + 2)
  end

  def help
    puts 'Available commands: '
    puts @@commands.sort_by { |c| c[0].to_s }.map { |a,c| "#{a} - #{c[0]}" }.join("\n")
  end

  def not_enough_arguments(c, a)
    puts "not enough arguments (#{a.size} for #{c.arity})"
  end

  def result_for_index(i)
    raise ArgumentError, 'index is required' if i.to_s =~ /\A\s*\z/
    raise InvalidIndex.new(i) if i.to_i <= 0
    @results[i.to_i-1] || raise(InvalidIndex.new(i))
  end

end
