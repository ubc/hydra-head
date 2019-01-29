# frozen_string_literal: true

module Valkyrie
  module Persistence
    class FedoraObjectFactory < ::Valkyrie::Persistence::Postgres::ResourceFactory
      # class << self
        # @param object [Valkyrie::Persistence::Postgres::ORM::Resource] AR
        #   record to be converted.
        # @return [Valkyrie::Resource] Model representation of the AR record.
        def to_resource(object:)
          if object.respond_to? :attributes_including_linked_ids
            vobj = object.valkyrie_resource.new(object.attributes.symbolize_keys)
            vobj.alternate_ids = [Valkyrie::ID.new(object.uri.to_s)]
            vobj
          else
            super
          end
        end

        # @param resource [Valkyrie::Resource] Model to be converted to ActiveRecord.
        # @return [Valkyrie::Persistence::Postgres::ORM::Resource] ActiveRecord
        #   resource for the Valkyrie resource.
        def from_resource(resource:)
          return super(resource: resource) unless resource.respond_to?(:fedora_model)

          translate_resource(resource)
        end

          private

            def translate_resource(resource, &block)
              hash = resource.to_h
              hash.delete(:internal_resource)
              hash.delete(:new_record)
              hash.delete(:alternate_ids)
              # Deal with these later
              hash.delete(:created_at)
              hash.delete(:updated_at)

              valkyrie_id = hash.delete(:id).to_s
              fedora_id = resource.alternate_ids.find {|v| v.to_s.start_with? ActiveFedora.fedora.base_uri }

              fedora_agent = resource.fedora_model.new(hash.compact)
              fedora_id = fedora_agent.class.uri_to_id(fedora_id) if fedora_id
              fedora_agent.id = fedora_id || valkyrie_id
              fedora_agent
            end
        # end
    end
  end
end
