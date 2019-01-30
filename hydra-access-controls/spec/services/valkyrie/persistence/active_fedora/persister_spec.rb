# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::ActiveFedora::Persister do
  let(:query_service) { adapter.query_service }
  let(:adapter) { Valkyrie::Persistence::ActiveFedora::MetadataAdapter.new }

  let(:persister) { adapter.persister }
  it_behaves_like "a Valkyrie::Persister"
end
