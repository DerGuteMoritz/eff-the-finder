require 'highline/import'
require 'launchy'

HighLine.track_eof = false

class F::Prompt

  attr_reader :results

  class InvalidIndex < StandardError

    def initialize(index)
      super "`#{index}' is not a valid index."
    end

  end

  @@commands = {
    :f => [ 'follow link',
            lambda { |r| Launchy.open(r.url.to_s) },
            { 0 => :result_for_index } ],

    :o => [ 'pass selected result to given command (%u for URL, %n for name)',
            lambda { |r, *cmd|
              c = cmd.join(' ').inject('u' => lambda { r.url }, 'n' => lambda { r.name }, '%' => lambda { '%' }) { |x,s| s.gsub(/%(#{x.keys.join('|')})/) { x[$1].call } }
              raise ArgumentError, 'command string is required' if c.blank?
              system(c)
            },
            { 0 => :result_for_index } ],

    :l => [ 'list results',
            :list ],

    :n => [ 'next page',
            :next_page ],

    :p => [ 'previous page',
            :previous_page ],

    :q => [ 'quit',
            lambda { exit } ]
  }

  def self.define(name, description, castings = { }, &block)
    @@commands[name.to_sym] = [description, block, castings]
  end

  protected

  def initialize(finder, results)
    @finder, @results = finder, results
    @commands = @@commands.merge(@finder.commands)
    list
    run
  end

  def list
    puts @finder.description
    puts @results.header
    puts

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
    loop { run_command(ask('f > ') { |q| q.readline = true } ) }
  end

  def http
    @finder.http
  end

  def absolutize_uri(u)
    @finder.absolutize_uri(u)
  end

  def run_command(s)
    command, args = parse_command_string(s)
    return help unless command
    command = method(command) unless command.respond_to? :call
    return not_enough_arguments(command, args) if args.size < command.arity
    instance_exec(*args, &command) || true
  rescue => e
    puts "Error: #{e}"
  end

  def parse_command_string(s)
    if s =~ /\A(\d+)\z/
      c = @commands[@finder.default_command || :f]
      args = [send(c[2][0], $1)]
    else
      c = @commands[s[/\A([a-z]+)/, 1].try(:to_sym)]
      args = Array(s[/\A[a-z]+(.*)/, 1].to_s.strip.split(/\s/))

      if c && c[2]
        c[2].each do |i, cast|
          args[i] = send(cast, (args[i]))
        end
      end
    end

    [c && c[1], args]
  end

  def with_padding(index)
    index.ljust(@results.size.to_s.length + 2)
  end

  def help
    puts 'Available commands: '
    puts @commands.sort_by { |c| c[0].to_s }.map { |a,c| "#{a} - #{c[0]}" }.join("\n")
  end

  def not_enough_arguments(c, a)
    puts "not enough arguments (#{a.size} for #{c.arity})"
  end

  def result_for_index(i)
    raise ArgumentError, 'index is required' if i.blank?
    raise InvalidIndex.new(i) if i.to_i <= 0
    @results[i.to_i-1] || raise(InvalidIndex.new(i))
  end

  def result_page_for_index(i)
    http.get(result_for_index(i).url)
  end

  def env(name)
    raise "environment variable #{name} is not set or empty" if ENV[name].blank?
    ENV[name]
  end

end
