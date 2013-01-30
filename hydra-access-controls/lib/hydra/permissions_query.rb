module Hydra::PermissionsQuery
  
  def permissions_doc(pid)
    @permissions_solr_document ||= get_permissions_solr_response_for_doc_id(pid)
  end


  protected

  # a solr query method
  # retrieve a solr document, given the doc id
  # Modeled on Blacklight::SolrHelper.get_permissions_solr_response_for_doc_id
  # @param [String] id of the documetn to retrieve
  # @param [Hash] extra_controller_params (optional)
  def get_permissions_solr_response_for_doc_id(id=nil, extra_controller_params={})
    raise Blacklight::Exceptions::InvalidSolrID.new("The application is trying to retrieve permissions without specifying an asset id") if id.nil?
    #solr_response = Blacklight.solr.get permissions_solr_doc_params(id).merge(extra_controller_params)
    #path = blacklight_config.solr_path
    solr_opts = permissions_solr_doc_params(id).merge(extra_controller_params)
    response = Blacklight.solr.get('select', :params=> solr_opts)
    solr_response = Blacklight::SolrResponse.new(force_to_utf8(response), solr_opts)

    raise Blacklight::Exceptions::InvalidSolrID.new("The solr permissions search handler didn't return anything for id \"#{id}\"") if solr_response.docs.empty?
    Hydra::PermissionsSolrDocument.new(solr_response.docs.first, solr_response)
  end

  #
  #  Solr integration
  #
  
  # returns a params hash with the permissions info for a single solr document 
  # If the id arg is nil, then the value is fetched from params[:id]
  # This method is primary called by the get_permissions_solr_response_for_doc_id method.
  # Modeled on Blacklight::SolrHelper.solr_doc_params
  # @param [String] id of the documetn to retrieve
  def permissions_solr_doc_params(id=nil)
    id ||= params[:id]
    # just to be consistent with the other solr param methods:
    {
      :qt => :permissions,
      :id => id # this assumes the document request handler will map the 'id' param to the unique key field
    }
  end
  
end
