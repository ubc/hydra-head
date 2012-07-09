require 'spec_helper'

describe Hydra::PermissionsController do
  before :all do
    @behavior = Hydra::PermissionsController.deprecation_behavior
    Hydra::PermissionsController.deprecation_behavior = :silence
  end

  after :all do
    Hydra::PermissionsController.deprecation_behavior = @behavior 
  end
  describe "create" do
    it "should create a new permissions entry" do
      @asset = ModsAsset.create
      post :create, :asset_id=>@asset.pid, :permission => {"actor_id"=>"_person_id_","actor_type"=>"person","access_level"=>"read"}      
      ModsAsset.find(@asset.pid).rightsMetadata.individuals.should == {"_person_id_" => "read"}
    end
  end
  describe "update" do
    it "should call Hydra::RightsMetadata properties setter" do
      @asset = ModsAsset.new
      @asset.rightsMetadata.permissions({:group=>"students"})
      @asset.save
      post :update, :asset_id=>@asset.pid, :permission => {"group"=>{"_group_id_"=>"discover"}}
      ModsAsset.find(@asset.pid).rightsMetadata.groups.should == {"_group_id_" => "discover"}
    end
  end
end
