# frozen_string_literal: true

module Valkyrie
  module Persistence
    class FedoraObjectAdapter
      def persister
        ::Valkyrie::Persistence::FedoraObjectPersister.new(adapter: self)
      end

      # @return [Class] {Valkyrie::Persistence::Postgres::QueryService}
      def query_service
        @query_service ||= ::Valkyrie::Persistence::FedoraObjectQueryService.new(adapter: self, resource_factory: resource_factory)
      end

      # @return [Class] {Valkyrie::Persistence::Postgres::ResourceFactory}
      def resource_factory
        ::Valkyrie::Persistence::FedoraObjectFactory.new(adapter: self)
      end
    end
  end
end
