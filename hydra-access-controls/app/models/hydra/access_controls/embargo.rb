module Hydra::AccessControls
  class Embargo < ActiveFedora::Base
    property :visibility_during_embargo, predicate: Hydra::ACL.visibilityDuringEmbargo, multiple:false
    property :visibility_after_embargo, predicate: Hydra::ACL.visibilityAfterEmbargo, multiple:false
    property :embargo_release_date, predicate: Hydra::ACL.embargoReleaseDate, multiple:false
    property :embargo_history, predicate: Hydra::ACL.embargoHistory

    def embargo_release_date=(date)
      date = DateTime.parse(date) if date.kind_of?(String)
      super(date)
    end

    def active?
      (embargo_release_date.present? && Date.today < embargo_release_date)
    end

    # Deactivates the embargo and logs a message to the embargo_history property
    def deactivate!
      return unless embargo_release_date
      embargo_state = active? ? "active" : "expired"
      embargo_record = embargo_history_message(embargo_state, Date.today, embargo_release_date, visibility_during_embargo, visibility_after_embargo)
      self.embargo_release_date = nil
      self.visibility_during_embargo = nil
      self.visibility_after_embargo = nil
      self.embargo_history += [embargo_record]
    end

    def to_hash
      {}.tap do |doc|
        date_field_name = Hydra.config.permissions.embargo.release_date.sub(/_dtsi/, '')
        ActiveFedora::Indexing::Inserter.insert_field(doc, date_field_name, embargo_release_date, :stored_sortable)
        doc[ActiveFedora.index_field_mapper.solr_name("visibility_during_embargo", :symbol)] = visibility_during_embargo unless visibility_during_embargo.nil?
        doc[ActiveFedora.index_field_mapper.solr_name("visibility_after_embargo", :symbol)] = visibility_after_embargo unless visibility_after_embargo.nil?
        doc[ActiveFedora.index_field_mapper.solr_name("embargo_history", :symbol)] = embargo_history unless embargo_history.nil?
      end
    end

    def valkyrie_resource
      # klass = "Valkyrie::#{self.class.to_s}".constantize
      @klass ||= "Hydra::AccessControls::Valkyrie::Embargo".constantize
    rescue NameError
      nil
    end

    def attributes_including_linked_ids
      local_attributes = attributes.dup
      reflections.keys.each do |key|
        id_method = "#{key.to_s.singularize}_ids"
        next unless self.respond_to? id_method
        local_attributes.merge!(id_method => self.send(id_method)).with_indifferent_access
      end
      local_attributes
    end

    protected

      # Create the log message used when deactivating an embargo
      # This method may be overriden in order to transform the values of the passed parameters.
      def embargo_history_message(state, deactivate_date, release_date, visibility_during, visibility_after)
        I18n.t 'hydra.embargo.history_message', state: state, deactivate_date: deactivate_date, release_date: release_date,
          visibility_during: visibility_during, visibility_after: visibility_after
      end
  end
end
