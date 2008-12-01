Merb::Config.use { |c|
  c[:framework]           = { :public => [Merb.root / "public", nil] }
  c[:session_store]       = 'none'
  c[:exception_details]   = true
  c[:log_level]           = :debug # or error, warn, info or fatal
  c[:log_stream]          = STDOUT
  c[:reload_classes]   = true
  c[:reload_templates] = true
}


Merb::Router.prepare do
end

class MerbSimple < Merb::Controller
  self._template_root = Merb.root / 'templates'
end

def template(t)
  render :template => t
end

def get(path,&blk) ; add_action(path,:get,&blk) ; end
def post(path,&blk) ; add_action(path,:post,&blk) ; end
def put(path,&blk) ; add_action(path,:put,&blk) ; end
def delete(path,&blk) ; add_action(path,:delete,&blk) ; end

def add_action(path, method, &blk)
  m = gen_mth(path,method)
  MerbSimple.class_eval do
    define_method(m,blk)
    show_action m
  end
  Merb::Router.prepare(Merb::Router.routes, []) do
    match(path).to(:controller => MerbSimple, :action => m, :method => method)
  end
end

def gen_mth(path,method)
  "s" + "_#{method}" + path.gsub(/\W/,'_')
end
