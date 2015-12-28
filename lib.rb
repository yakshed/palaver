require 'seg'

class Palaver
  class << self
    attr_accessor :knoedel

    def define(name=nil, &b)
      self.knoedel = {
        name: name,
        code: b
      }
    end
  end

  def define(name=nil, &b)
    query = Rack::Utils.parse_query(@env['QUERY_STRING'])
      .inject({}) do |obj, (key, value)|
        obj[key.to_sym] = value
        obj
      end
    yield(query)
  end

  def on(segment, &b)
    if b.arity > 0
      inbox = {}
      x = @seg.capture(segment, inbox)
      yield(inbox[segment]) if x
    else
      yield if @seg.consume(segment)
    end
  end

  def get(&b)
    b[@req, @res] if @seg.root?
  end

  def call(env)
    @env = env
    @req = Rack::Request.new(env)
    @res = Rack::Response.new
    @seg = Seg.new(env.fetch(Rack::PATH_INFO))

    instance_eval(&self.class.knoedel[:code])
    @res.finish
  end
end
