require 'spec_helper'

describe SolrDocument do
  describe "#to_model" do
    before do
      class SolrDocumentWithHydraOverride < SolrDocument
        include Hydra::Solr::Document
      end
    end

    # this isn't a great test, but...
    it "tries to cast the SolrDocument to the Fedora object" do
      expect(ActiveFedora::Base).to receive(:load_instance_from_solr).with('asdfg', kind_of(described_class))
      SolrDocumentWithHydraOverride.new(id: 'asdfg').to_model
    end
  end
end
