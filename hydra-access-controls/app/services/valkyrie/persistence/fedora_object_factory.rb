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
            byebug
            vobj = object.valkyrie_resource.new(object.attributes.symbolize_keys)
            vobj.alternate_ids = [object.id.to_s]
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
              byebug
              hash = resource.to_h
              hash.delete(:internal_resource)
              hash.delete(:new_record)
              # hash[:id] = hash[:id].to_s
              valkyrie_id = hash.delete(:id).to_s
              # if valkyrie_id.present?
              #   fedora_agent = resource.fedora_model.find(valkyrie_id.id)
              #   fedora_agent.update(hash.compact)
              # else
              fedora_agent = resource.fedora_model.new(hash.compact)
              fedora_agent.id = valkyrie_id
              # end
              # block.yield(fedora_agent)
              fedora_agent
            end
        # end
    end
  end
end
