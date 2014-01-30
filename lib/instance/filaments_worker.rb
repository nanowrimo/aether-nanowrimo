Aether::Instance.require_user(:instance, 'filaments_application')

class Nano::FilamentsWorker < Nano::FilamentsApplication
  self.type = "filaments-worker"
end
