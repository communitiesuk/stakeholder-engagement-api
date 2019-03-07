class ConsiderAllRequestsJsonMiddleware
  def initialize app
    @app = app
  end

  def call(env)
    env["CONTENT_TYPE"] = 'application/json'
    env["HTTP_ACCEPT"] = "application/json;#{env['HTTP_ACCEPT']}"
    @app.call(env)
  end
end
