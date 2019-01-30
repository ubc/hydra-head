# frozen_string_literal: true

module Valkyrie
  module Persistence
    module ActiveFedora
      class ResourceFactory
        attr_reader :adapter
        delegate :id, to: :adapter, prefix: true

        # @param [MetadataAdapter] adapter
        def initialize(adapter:)
          @adapter = adapter
        end

        # @param object [ActiveFedora::Base] AF
        #   record to be converted.
        # @return [Valkyrie::Resource] Model representation of the AF record.
        def to_resource(object:)
          object.valkyrie_resource.new(object.attributes.symbolize_keys)
        end

        # @param resource [Valkyrie::Resource] Model to be converted to ActiveRecord.
        # @return [ActiveFedora::Base] ActiveFedora
        #   resource for the Valkyrie resource.
        def from_resource(resource:)
          af_object = resource.fedora_model.new(af_attributes(resource))
          af_object.id = af_id(resource)
          af_object
        end

        private

          def af_attributes(resource)
            hash = resource.to_h
            hash.delete(:internal_resource)
            hash.delete(:new_record)
            hash.delete(:id)
            hash.delete(:alternate_ids)
            # Deal with these later
            hash.delete(:created_at)
            hash.delete(:updated_at)
            hash.compact
          end

          def af_id(resource)
            valkyrie_id = resource.id.to_s
            fedora_id = resource.alternate_ids.find {|v| v.to_s.start_with? ActiveFedora.fedora.base_uri }
            if fedora_id
              fedora_agent.class.uri_to_id(fedora_id)
            else
              valkyrie_id
            end
          end

          def translate_resource(resource)
            hash = resource.to_h
            hash.delete(:internal_resource)
            hash.delete(:new_record)
            valkyrie_id = hash.delete(:id)
            return resource.fedora_model.new(hash.compact)
          end
        end
      end
    end
  end
