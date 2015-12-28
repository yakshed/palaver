class Palaver
  class Request
    def initialize(env)
      @env = env
    end
  end

  class Response
    def finish
      [200, {}, ['pups']]
    end
  end

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
  end

  def on(segment, &b)
  end

  def run(app)
  end

  def call(env)
    @env = env
    @req = Request.new(env)
    @res = Response.new

    instance_eval(&self.class.knoedel[:code])
    @res.finish
  end
end
