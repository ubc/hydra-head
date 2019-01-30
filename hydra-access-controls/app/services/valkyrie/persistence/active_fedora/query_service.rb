# frozen_string_literal: true

module Valkyrie
  module Persistence
    module ActiveFedora
      class QueryService
        attr_reader :resource_factory, :adapter
        delegate :orm_class, to: :resource_factory

        # @param [ResourceFactory] resource_factory
        def initialize(adapter:, resource_factory:)
          @resource_factory = resource_factory
          @adapter = adapter
        end

        # Find a record using a Valkyrie ID, and map it to a Valkyrie Resource
        # @param [Valkyrie::ID, String] id
        # @return [Valkyrie::Resource]
        # @raise [Valkyrie::Persistence::ObjectNotFoundError]
        def find_by(id:)
          resource_factory.to_resource(object: ::ActiveFedora::Base.find(id.to_s))
        rescue ::ActiveFedora::ObjectNotFoundError
          raise ::Valkyrie::Persistence::ObjectNotFoundError
        end

        # # Retrieve all records for the resource and construct Valkyrie Resources
        # #   for each record
        # # @return [Array<Valkyrie::Resource>]
        # def find_all
        #   ActiveFedora::Base.all
        # end
        #
        # # Retrieve all records for a specific resource type and construct Valkyrie
        # #   Resources for each record
        # # @param [Class] model
        # # @return [Array<Valkyrie::Resource>]
        # def find_all_of_model(model:)
        #   model.all
        # end
        #
        # # Find and a record using a Valkyrie ID for an alternate ID, and construct
        # #   a Valkyrie Resource
        # # @param [Valkyrie::ID] alternate_identifier
        # # @return [Valkyrie::Resource]
        # def find_by_alternate_identifier(alternate_identifier:)
        #   raise NotImplementedError
        # end
        #
        # # Find records using a set of Valkyrie IDs, and map each to Valkyrie
        # #   Resources
        # # @param [Array<Valkyrie::ID>] ids
        # # @return [Array<Valkyrie::Resource>]
        # def find_many_by_ids(ids:)
        #   ids.collect { |id| find_by(id: id) }
        # end
        #
        # # Find all member resources for a given Valkyrie Resource
        # # @param [Valkyrie::Resource] resource
        # # @param [Class] model
        # # @return [Array<Valkyrie::Resource>]
        # def find_members(resource:, model: nil)
        #   resource&.members&.select { |member| member.is_a? model }
        # end
        #
        # # Find all parent resources for a given Valkyrie Resource
        # # @param [Valkyrie::Resource] resource
        # # @return [Array<Valkyrie::Resource>]
        # def find_parents(resource:)
        #   resource&.member_of
        # end
        #
        # # Find all resources related to a given Valkyrie Resource by a property
        # # @param [Valkyrie::Resource] resource
        # # @param [String] property
        # # @return [Array<Valkyrie::Resource>]
        # def find_references_by(resource:, property:)
        #   raise NotImplementedError
        # end
        #
        # # Find all resources referencing a given Valkyrie Resource by a property
        # # @param [Valkyrie::Resource] resource
        # # @param [String] property
        # # @return [Array<Valkyrie::Resource>]
        # def find_inverse_references_by(resource:, property:)
        #   raise NotImplementedError
        # end
        #
        # # Constructs a Valkyrie::Persistence::CustomQueryContainer using this query service
        # # @return [Valkyrie::Persistence::CustomQueryContainer]
        # def custom_queries
        #   @custom_queries ||= ::Valkyrie::Persistence::CustomQueryContainer.new(query_service: self)
        # end
      end
    end
  end
end
