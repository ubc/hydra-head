require 'spec_helper'

describe RoleMapper do
  before do
    allow(Devise).to receive(:authentication_keys).and_return(['uid'])
  end

  it "defines the 4 roles" do
    expect(described_class.role_names.sort).to eq %w(admin_policy_object_editor archivist donor patron researcher)
  end
  it "is quer[iy]able for roles for a given user" do
    expect(described_class.roles('leland_himself@example.com').sort).to eq ['archivist', 'donor', 'patron']
    expect(described_class.roles('archivist2@example.com')).to eq ['archivist']
  end

  it "doesn't change its response when it's called repeatedly" do
    u = User.new(uid: 'leland_himself@example.com')
    allow(u).to receive(:new_record?).and_return(false)
    expect(described_class.roles(u).sort).to eq ['archivist', 'donor', 'patron', "registered"]
    expect(described_class.roles(u).sort).to eq ['archivist', 'donor', 'patron', "registered"]
  end

  it "returns an empty array if there are no roles" do
    expect(described_class.roles('zeus@olympus.mt')).to be_empty
  end

  it "knows who is what" do
    expect(described_class.whois('archivist').sort).to eq %w(archivist1@example.com archivist2@example.com leland_himself@example.com)
    expect(described_class.whois('salesman')).to be_empty
    expect(described_class.whois('admin_policy_object_editor').sort).to eq %w(archivist1@example.com)
  end
end
