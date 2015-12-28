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
      yield(@path.shift) unless @path.empty?
    else
      if @path.first == segment
        @path.shift
        yield
      end
    end
  end

  def get(&b)
    b[@req, @res] if @path.empty?
  end

  def call(env)
    @env = env
    @req = Rack::Request.new(env)
    @res = Rack::Response.new
    @path = env.fetch(Rack::PATH_INFO).split('/')
    @path.shift

    instance_eval(&self.class.knoedel[:code])
    @res.finish
  end
end
