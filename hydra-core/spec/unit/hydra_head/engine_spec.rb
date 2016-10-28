require 'spec_helper'

describe HydraHead::Engine do
  it "is a subclass of Rails::Engine" do
    expect(described_class.superclass).to eq Rails::Engine
  end
end
