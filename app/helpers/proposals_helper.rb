module ProposalsHelper
  
  def proposal_list_item(proposal)
    ret = link_to(proposal.title, proposal_url(proposal))
    ret += "&nbsp;-&nbsp;" + proposal.name
    return ret
  end
  
end
