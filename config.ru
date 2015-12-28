require File.expand_path("lib", __dir__)

class App < Palaver
  define do
    on('todos') do
      define(:todos) do
        get do |req, res|
          res.write 'Todos called'
        end

        on(:id) do |id| # id is the path parameter
          define(:todo) do |bar:| # bar is a required query parameter, for optional use default value
            get do |req, res|
              res.write "Here, a single todo with id #{id} and bar #{bar}"
            end
          end
        end
      end
    end
  end
end

run(App.new)
