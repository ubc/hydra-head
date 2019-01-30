# frozen_string_literal: true

module Valkyrie
  module Persistence
    module ActiveFedora
      class MetadataAdapter
        # @return [Class] {Valkyrie::Persistence::ActiveFedora::Persister}
        def persister
          Valkyrie::Persistence::ActiveFedora::Persister.new(adapter: self)
        end

        # @return [Class] {Valkyrie::Persistence::ActiveFedora::QueryService}
        def query_service
          @query_service ||= Valkyrie::Persistence::ActiveFedora::QueryService.new(adapter: self, resource_factory: resource_factory)
        end

        # @return [Class] {Valkyrie::Persistence::ActiveFedora::ResourceFactory}
        def resource_factory
          Valkyrie::Persistence::ActiveFedora::ResourceFactory.new(adapter: self)
        end
      end
    end
  end
end
