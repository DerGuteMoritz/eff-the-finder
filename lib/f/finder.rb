require 'httparty'
require 'rfuzz/client'
require 'nokogiri'

class F::Finder

  class UnknownFinderError < NameError
  end

  class << self

    @@finders = {}

    def define(name, &block)
      finder = new.extend(HTTParty)
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

  def run(args)
    if args.empty?
      puts description
    else
      prompt(find(args))
    end
  end

  protected

  attr :description

  def base_uri(u = nil)
    @base_uri = URI.parse(u) if u
    @base_uri
  end

  def find(args)
    @http ||= RFuzz::HttpClient.new(base_uri.host, base_uri.port)
    @parse.call(Nokogiri(@list.call(@http, args).http_body), result = F::Result.new(self))
    return result
  end

  def list(&block)
    @list = block
  end

  def parse(&block)
    @parse = block
  end

  def prompt(results)
    F::Prompt.new(results)
  end

end
