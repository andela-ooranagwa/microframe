require File.join(__dir__, "../","controller", "application_controller")
require File.join(__dir__, "mapper")

module Microframe
  class Router
    attr_reader :routes, :mapper, :object
    attr_accessor :request

    def initialize
      @routes = Hash.new
    end

    def handle_request
      verb = request.request_method
      path = request.path_info
      @mapper ||= Mapper.start(routes)
      handler = @mapper.map(verb, path) #get_handler(verb, path)

      return missing_path unless handler

      request.params.merge!(@mapper.placeholders)

      response = setup_controller(handler)
      unless object.view_rendered
        response = object.render_view
      end
      response
    end

    def setup_controller(handler)
      controller = handler[:controller]
      action = handler[:action]
      get_handler_file(controller)

      @object = Module.const_get(controller.capitalize + "Controller").new(request, controller, action)
      object.send(action.to_sym)
    end


    def self.setup_verbs(*verbs)
      verbs.each do |verb|
        define_method(verb) { |path, handler| set_route(verb.to_s.upcase, path, handler) }
      end
    end

    setup_verbs :get, :post, :patch, :put, :delete

    def draw(&block)
      instance_eval(&block)
      @routes.default = {}
    end

    def resources(name)
      name = name.to_s
      get("/#{name}", to: "#{name}#index")
      get("/#{name}/new", to: "#{name}#new")
      get("/#{name}/:id", to: "#{name}#show")
      get("/#{name}/:id/edit", to: "#{name}#edit")
      post("/#{name}", to: "#{name}#create")
      patch("/#{name}/:id", to: "#{name}#update")
      put("/#{name}/:id", to: "#{name}#update")
      delete("/#{name}/:id", to: "#{name}#destroy")
    end

    private

    def get_handler(verb, path)
      routes[verb][path]
    end

    def set_route(verb, path, handler = {})
      @routes[verb] ||= {}
      @routes[verb][path] = setup_handler(handler)
    end

    def setup_handler(handler)
      controller, action = handler[:to].split("#")
      {controller: controller, action: action}
    end

    def get_handler_file(controller)
      require File.join(APP_PATH, "app", "controllers",  controller + "_controller")
    end

    def missing_path
      [404, {"Content-Type" => "application/html"}, ["<p>We are here but unfortunately, this page: #{request.host}#{request.path_info} isn't. Return home while we keep looking for it.</p>"]]
    end
  end
end
