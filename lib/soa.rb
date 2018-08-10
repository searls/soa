require "soa/version"

class SOA
  ServiceCall = Struct.new(:route, :service, :args)

  def self.register(route, blk)
    @services ||= {}
    @services[route] = blk
  end

  def self.invoke(url)
    service_call = service_lookup(url)
    service_call.service.call(*service_call.args)
  end

  private

  def self.service_lookup(url)
    route, service = @services.find { |(route, _)|
      parse_params(route, url).all? { |(route_component, url_component)|
        route_component == url_component || route_component.start_with?(":")
      }
    }

    return ServiceCall.new(route, service, parse_args(route, url))
  end

  def self.parse_params(route, url)
    route.split("/").zip(url.split("/"))
  end

  def self.parse_args(route, url)
    parse_params(route, url).select { |(route_component, _)|
      route_component.start_with?(":")
    }.map { |(_, url_component)|
      url_component
    }
  end

end

module Kernel
  def service(route, &blk)
    Soa.register(route, blk)
  end

  def call_service(url, *args)
    Soa.invoke(url, *args)
  end
end
