require 'mechanize'

class F::Finder

  class UnknownFinderError < NameError
  end

  class << self

    @@finders = {}

    def define(name, &block)
      finder = new
      finder.instance_eval(&block)
      @@finders[name] = finder
    end

    def get(a)
      ff = @@finders.select { |f, x| f.to_s =~ /\A#{Regexp.escape(a)}/ }
      raise UnknownFinderError.new("Sorry, I don't know a finder named `#{a}'.") if ff.empty?
      raise UnknownFinderError.new("There is more than one possible match for `#{s}: #{ff.keys.join(', ')}.") if ff.size > 1
      ff[0][1]
    rescue UnknownFinderError => e
      puts e
      exit 1
    end

    def summary
      max = @@finders.keys.map { |k| k.to_s.size }.max
      @@finders.map { |name, f| [name.to_s.ljust(max), '   ', f.description, "(#{f.base_uri})"].join(' ') }.join("\n")
    end

    def attr(*names)
      names.each do |name|
        class_eval <<-end_class_eval, __FILE__, __LINE__
          def #{name}(v = nil)
            @#{name} = v if v
            @#{name}
          end
        end_class_eval
      end
    end

  end

  attr_reader :commands

  def initialize
    @commands = { }
  end

  def run(args)
    if args.empty?
      puts description
    else
      prompt(load(args))
    end
  end

  def find_by_url(url)
    parse(http.get(url))
  end

  def http
    @http ||=  WWW::Mechanize.new do |m|
      m.user_agent = 'Eff the Finder'
      m.get(base_uri)
    end
  end

  def base_uri(u = nil)
    @base_uri = URI.parse(u) if u
    @base_uri
  end

  def absolutize_uri(u)
    uri = URI.parse(u.to_s.gsub('[', '%5B').gsub(']', '%5D'))
    uri = base_uri.merge(uri) unless uri.absolute?
    uri
  end

  protected

  attr :description

  def load(args)
    parse(find(args))
  end

  def find(args = nil, &block)
    if block_given?
      @find = block
    else
      @find.call(http, { :args => args, :terms => args.join(' ') } )
    end
  end

  def parse(response = nil, &block)
    if block_given?
      @parse = block
    else
      @parse.call(response, result = F::Result.new(self))
      return result
    end
  end

  def command(name, description, castings = { }, &block)
    @commands[name.to_sym] = [description, block, castings]
  end

  def prompt(results)
    F::Prompt.new(self, results)
  end

end
