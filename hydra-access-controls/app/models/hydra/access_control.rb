module Hydra
  class AccessControl < ActiveFedora::Base

    before_destroy do |obj|
      contains.destroy_all
    end

    is_a_container class_name: 'Hydra::AccessControls::Permission'
    accepts_nested_attributes_for :contains, allow_destroy: true

    attr_accessor :owner

    def permissions
      relationship
    end

    def permissions=(records)
      relationship.replace(records)
    end

    def permissions_attributes=(attribute_list)
      raise ArgumentError unless attribute_list.is_a? Array
      process_deletes(attribute_list) + process_edits(attribute_list)
    end

    def process_deletes(attribute_list)
      attribute_list.each do |attributes|
        next unless has_destroy_flag?(attributes)
        obj = relationship.find(attributes[:id])
        obj.destroy if attributes.key?(:id)      
      end
    end

    def process_edits(attribute_list)
      attribute_list.each do |attributes|
        next if has_destroy_flag?(attributes)
        obj = relationship.find(attributes.delete(:id))
        if obj && obj.persisted?
          obj.update(attributes.except(:_destroy))
        else
          relationship.create(attributes)
        end
      end
    end

    def relationship
      @relationship ||= CollectionRelationship.new(self, :contains)
    end

    class CollectionRelationship
      def initialize(owner, reflection)
        @owner = owner
        @relationship = @owner.send(reflection)
      end

      delegate :to_a, :to_ary, :map, :delete, :first, :last, :size, :count, :[],
               :==, :detect, :empty?, :each, :any?, :all?, :include?, :destroy_all,
               to: :@relationship

      # TODO: if directly_contained relationships supported find, we could just
      # delegate find.
      def find(id)
        return to_a.find { |record| record.id == id } if @relationship.loaded?
        
        unless id.start_with?(@owner.id)
          raise ArgumentError, "requested ACL (#{id}) is not a member of #{@owner.id}"
        end
        ActiveFedora::Base.find(id)
      end

      # adds one to the target.
      def build(attributes)
        @relationship.build(attributes) do |record|
          record.access_to = @owner.owner
        end
      end

      def create(attributes)
        build(attributes).tap(&:save!)
      end

      def replace(*args)
        @relationship.replace(*args)
      end
    end
  end
end
