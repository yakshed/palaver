require File.expand_path("lib", __dir__)

class Todos < Palaver
  define(:todos) do
    get do
      res.write 'Todos called'
    end

    on(:id) do |id| # id is the path parameter
      define(:todo) do |bar| # bar is a query parameter
        get do
          res.write "Here, a single todo with id #{id} and bar #{bar}"
        end
      end
    end
  end
end

class App < Palaver
  define do
    on('todos') do
      run Todos
    end
  end
end

run(App.new)
