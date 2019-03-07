class ConsiderAllRequestsJsonMiddleware
  def initialize app
    @app = app
  end

  def call(env)
    if env["CONTENT_TYPE"] == 'application/x-www-form-urlencoded'
      env["CONTENT_TYPE"] = 'application/json'
    end
    @app.call(env)
  end
end
