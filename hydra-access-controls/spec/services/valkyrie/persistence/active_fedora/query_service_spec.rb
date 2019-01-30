# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::ActiveFedora::QueryService do
  let(:adapter) { Valkyrie::Persistence::ActiveFedora::MetadataAdapter.new }
  it_behaves_like "a Valkyrie query provider"
end
