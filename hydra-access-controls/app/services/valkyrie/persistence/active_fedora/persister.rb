# frozen_string_literal: true

module Valkyrie
  module Persistence
    module ActiveFedora
      class Persister
        attr_reader :adapter
        delegate :resource_factory, to: :adapter

        # @param [MetadataAdapter] adapter
        def initialize(adapter:)
          @adapter = adapter
        end

        # Persists a resource using ActiveFedora
        # @param [Valkyrie::Resource] resource
        # @return [Valkyrie::Resource] the persisted/updated resource
        def save(resource:)
          af_object = resource_factory.from_resource(resource: resource)
          af_object.save!
          resource_factory.to_resource(object: af_object)
        end

        # # Persists a set of resources using ActiveFedora
        # # @param [Array<Valkyrie::Resource>] resources
        # # @return [Array<Valkyrie::Resource>] the persisted/updated resources
        # def save_all(resources:)
        #   resources.map do |resource|
        #     save(resource: resource)
        #   end
        # end

        # Deletes a resource persisted using ActiveFedora
        # @param [Valkyrie::Resource] resource
        # @return [Valkyrie::Resource] the deleted resource
        def delete(resource:)
          af_object = resource_factory.from_resource(resource: resource)
          af_object.delete #TODO: eradicate as well?
          resource
        end

        # # Deletes all resources of a specific Valkyrie Resource type persisted in
        # #   Fedora
        # def wipe!
        #   ActiveFedora::Base.delete_all
        # end
      end
    end
  end
end
