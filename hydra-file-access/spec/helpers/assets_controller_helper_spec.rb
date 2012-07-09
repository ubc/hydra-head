require 'spec_helper'

describe Hydra::AssetsControllerHelper do
  describe "sanitize_update_params" do
    it "should create a hash appropriate for passing into ActiveFedora::Base.update_datastream_attributes" do
      sample_params = {
        "content_type"=>"mods_asset", 
        "action"=>"update", 
        "_method"=>"put", 
        "field_selectors"=>{
          "descMetadata"=>{"person_0_computing_id"=>[{"person"=>"0"}, "computing_id"], "journal_0_issue_start_page"=>[{"journal"=>"0"}, "issue", "start_page"], "person_1_description"=>[{"person"=>"1"}, "description"], "person_1_institution"=>[{"person"=>"1"}, "institution"], "journal_0_origin_info_publisher"=>[{"journal"=>"0"}, "origin_info", "publisher"], "abstract"=>["abstract"], "person_0_last_name"=>[{"person"=>"0"}, "last_name"], "person_0_description"=>[{"person"=>"0"}, "description"], "journal_0_issue_volume"=>[{"journal"=>"0"}, "issue", "volume"], "title_info_main_title"=>["title_info", "main_title"], "location_url"=>["location", "url"], "note"=>["note"], "person_1_last_name"=>[{"person"=>"1"}, "last_name"], "subject_topic"=>["subject", "topic"], "person_0_institution"=>[{"person"=>"0"}, "institution"], "person_1_first_name"=>[{"person"=>"1"}, "first_name"], "person_1"=>[{"person"=>"1"}], "journal_0_title_info_main_title"=>[{"journal"=>"0"}, "title_info", "main_title"], "journal_0_issue_level"=>[{"journal"=>"0"}, "issue", "level"], "journal_0_issue_end_page"=>[{"journal"=>"0"}, "issue", "end_page"], "peer_reviewed"=>["peer_reviewed"], "person_0_first_name"=>[{"person"=>"0"}, "first_name"], "person_1_computing_id"=>[{"person"=>"1"}, "computing_id"], "journal_0_issn"=>[{"journal"=>"0"}, "issn"], "journal_0_issue_publication_date"=>[{"journal"=>"0"}, "issue", "publication_date"], "subject_topic" => ["subject", "topic", "subject", "topic"]}, 
          "rightsMetadata"=>{"embargo_embargo_release_date"=>["embargo", "embargo_release_date"]}, 
          "properties"=>{"release_to"=>["release_to"]}
          }, 
        "id"=>"hydrangea:fixture_mods_article3", 
        "controller"=>"assets", 
        "asset"=>{"descMetadata"=>{"person_0_computing_id"=>{"0"=>""}, "journal_0_issue_start_page"=>{"0"=>"195"}, "person_1_description"=>{"0"=>""}, "person_1_institution"=>{"0"=>"Baltimore"}, "journal_0_origin_info_publisher"=>{"0"=>"PUBLISHER"}, "abstract"=>{"0"=>"ABSTRACT"}, "person_0_last_name"=>{"0"=>"Smith"}, "person_0_description"=>{"0"=>""}, "journal_0_issue_volume"=>{"0"=>"2               "}, "title_info_main_title"=>{"0"=>"Test Article"}, "location_url"=>{"0"=>"http://example.com/foo"}, "note"=>{"0"=>""}, "person_1_last_name"=>{"0"=>"Lacks"}, "subject_topic"=>{"0"=>"TOPIC 1", "1"=>"TOPIC 2", "2"=>"CONTROLLED TERM"}, "person_0_institution"=>{"0"=>"FACULTY, UNIVERSITY"}, "person_1_first_name"=>{"0"=>"Henrietta"}, "journal_0_title_info_main_title"=>{"0"=>"The Journal of Mock Object"}, "journal_0_issue_level"=>{"0"=>""}, "journal_0_issue_end_page"=>{"0"=>"230"}, "person_0_first_name"=>{"0"=>"John"}, "person_1_computing_id"=>{"0"=>""}, "journal_0_issn"=>{"0"=>"1234-5678"}, "journal_0_issue_publication_date"=>{"0"=>"FEB. 2007"}, "subject_topic" => {"0"=>"Topic1", "1"=>"Topic2"}}, "rightsMetadata"=>{"embargo_embargo_release_date"=>{"0"=>""}}, "properties"=>{"released"=>{"0"=>"true"}, "release_to"=>{"0"=>"public"}}}
        }
      
      expected_sane_params = {
        "descMetadata"=>{[{:person=>0}, :institution]=>{"0"=>"FACULTY, UNIVERSITY"}, [{:journal=>0}, :title_info, :main_title]=>{"0"=>"The Journal of Mock Object"}, [{:journal=>0}, :issue, :volume]=>{"0"=>"2               "}, [{:journal=>0}, :issn]=>{"0"=>"1234-5678"}, [{:person=>1}, :first_name]=>{"0"=>"Henrietta"}, [{:person=>0}, :last_name]=>{"0"=>"Smith"}, [:location, :url]=>{"0"=>"http://example.com/foo"}, [:subject, :topic]=>{"0"=>"TOPIC 1", "1"=>"TOPIC 2", "2"=>"CONTROLLED TERM"}, [{:person=>0}, :first_name]=>{"0"=>"John"}, [{:person=>1}, :computing_id]=>{"0"=>""}, [{:journal=>0}, :issue, :end_page]=>{"0"=>"230"}, [:note]=>{"0"=>""}, [:title_info, :main_title]=>{"0"=>"Test Article"}, [{:journal=>0}, :issue, :publication_date]=>{"0"=>"FEB. 2007"}, [{:person=>1}, :description]=>{"0"=>""}, [:abstract]=>{"0"=>"ABSTRACT"}, [{:journal=>0}, :issue, :level]=>{"0"=>""}, [{:person=>1}, :institution]=>{"0"=>"Baltimore"}, [{:person=>0}, :computing_id]=>{"0"=>""}, [{:person=>1}, :last_name]=>{"0"=>"Lacks"}, [{:journal=>0}, :issue, :start_page]=>{"0"=>"195"}, [{:person=>0}, :description]=>{"0"=>""}, [{:journal=>0}, :origin_info, :publisher]=>{"0"=>"PUBLISHER"}, [:subject, :topic]=>{"0"=>"Topic1", "1"=>"Topic2"} }, "rightsMetadata"=>{[:embargo, :embargo_release_date]=>{"0"=>""}}, 
        "properties"=>{[:release_to]=>{"0"=>"public"}, :released=>{"0"=>"true"}}
        }
      helper.stub(:params).and_return(sample_params)
      sanitized_params = helper.sanitize_update_params
      sanitized_params.should == expected_sane_params
      sanitized_params["descMetadata"].should == expected_sane_params["descMetadata"]
    end
  end
  
  describe "tidy_response_from_update" do
    it "should put response values into an array with fieldname / index / value Hash for each field updated" do
      sample_input = {"descMetadata"=>{"journal_0_issue_start_page"=>{"0"=>"195"}, "person_0_computing_id"=>{"-1"=>""}, "journal_0_origin_info_publisher"=>{"0"=>"PUBLISHER"}, "person_1_institution"=>{"0"=>"Baltimore"}, "person_1_description"=>{"-1"=>""}, "abstract"=>{"0"=>"ABSTRACT"}, "person_0_description"=>{"-1"=>""}, "person_0_last_name"=>{"0"=>"Smith"}, "journal_0_issue_volume"=>{"0"=>"2               "}, "title_info_main_title"=>{"0"=>"Matt's Test Article! Again!?"}, "note"=>{"-1"=>""}, "location_url"=>{"0"=>"http://example.com/foo"}, "person_1_last_name"=>{"0"=>"Lacks"}, "subject_topic"=>{"0"=>"TOPIC 1", "1"=>"TOPIC 2", "2"=>"CONTROLLED TERM"}, "journal_0_issue_level"=>{"0"=>"55       "}, "journal_0_issue_end_page"=>{"0"=>"230"}, "person_1_first_name"=>{"0"=>"Henrietta"}, "person_0_institution"=>{"0"=>"FACULTY, UNIVERSITY"}, "journal_0_title_info_main_title"=>{"0"=>"The Journal of Mock Object"}, "journal_0_issue_publication_date"=>{"0"=>"FEB. 2007"}, "person_1_computing_id"=>{"-1"=>""}, "person_0_first_name"=>{"0"=>"John"}, "journal_0_issn"=>{"0"=>"1234-5678"}}, "rightsMetadata"=>{"embargo_embargo_release_date"=>{"-1"=>""}}, "properties"=>{:released=>{"0"=>"true"}, :release_to=>{"0"=>"public"}, [:release_to]=>{}}}
      expected_output = {"updated"=>[{"value"=>{"0"=>"195"}, "index"=>"journal_0_issue_start_page", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"person_0_computing_id", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"PUBLISHER"}, "index"=>"journal_0_origin_info_publisher", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"Baltimore"}, "index"=>"person_1_institution", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"person_1_description", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"ABSTRACT"}, "index"=>"abstract", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"person_0_description", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"Smith"}, "index"=>"person_0_last_name", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"2               "}, "index"=>"journal_0_issue_volume", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"Matt's Test Article! Again!?"}, "index"=>"title_info_main_title", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"note", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"http://example.com/foo"}, "index"=>"location_url", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"Lacks"}, "index"=>"person_1_last_name", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"TOPIC 1", "1"=>"TOPIC 2", "2"=>"CONTROLLED TERM"}, "index"=>"subject_topic", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"55       "}, "index"=>"journal_0_issue_level", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"230"}, "index"=>"journal_0_issue_end_page", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"Henrietta"}, "index"=>"person_1_first_name", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"FACULTY, UNIVERSITY"}, "index"=>"person_0_institution", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"The Journal of Mock Object"}, "index"=>"journal_0_title_info_main_title", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"FEB. 2007"}, "index"=>"journal_0_issue_publication_date", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"person_1_computing_id", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"John"}, "index"=>"person_0_first_name", "field_name"=>"descMetadata"}, {"value"=>{"0"=>"1234-5678"}, "index"=>"journal_0_issn", "field_name"=>"descMetadata"}, {"value"=>{"-1"=>""}, "index"=>"embargo_embargo_release_date", "field_name"=>"rightsMetadata"}, {"value"=>{"0"=>"true"}, "index"=>:released, "field_name"=>"properties"}, {"value"=>{"0"=>"public"}, "index"=>:release_to, "field_name"=>"properties"}, {"value"=>{}, "index"=>[:release_to], "field_name"=>"properties"}]}
      result = helper.tidy_response_from_update(sample_input)
      (expected_output["updated"] - result["updated"]).should == []
    end
    it "if handling submission from jeditable (which will only submit one value at a time), return the value it submitted" do
      sample_input = {"descMetadata"=>{"journal_0_issue_start_page"=>{"0"=>"195"}} }
      expected_output = {"0"=>"195"}
      helper.stub(:params).and_return({:field_id => "my field id"})
      helper.tidy_response_from_update(sample_input).should == expected_output
    end
  end
  
  describe "update_document" do
    it "should update the document with the provided params" do
      sample_params = "sample params"
      mock_document = mock("document")
      mock_document.should_receive(:update_datastream_attributes).with(sample_params)
      helper.update_document(mock_document, sample_params)
    end
  end
  
  describe "send_datastream" do
    it "should return the requested datastream with content disposition & mime type set from datastream attributes" do
      test_ds = ModsAsset.find("hydrangea:fixture_file_asset1").datastreams["DS1"]
      helper.should_receive(:send_data).with(test_ds.content, :filename=>"bali.jpg", :type=>"image/jpeg")
      helper.send(:send_datastream, test_ds)
    end
  end
  
end
