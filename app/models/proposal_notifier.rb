class ProposalNotifier < ActionMailer::Base
  
  def admin_notification(proposal)
    recipients  proposal.ignite.emails_as_array
    from        "#{proposal.ignite.name} \<no-reply@#{proposal.ignite.domain}\>"
    subject     "#{proposal.name} submitted proposal #{proposal.title}"
    body        ({ :proposal => proposal })
  end
  
  def thank_you(proposal)
    recipients  proposal.email
    from        "#{proposal.ignite.name} \<no-reply@#{proposal.ignite.domain}\>"
    subject     "Thank you for submitting your proposal"
    body        ({ :proposal => proposal })
  end
  
  def admin_comment_notification(comment, proposal)
    recipients  proposal.ignite.emails_as_array
    from        "#{proposal.ignite.name} \<no-reply@#{proposal.ignite.domain}\>"
    subject     "Someone commented on a proposal"
    body        ({ :proposal => proposal, :comment => comment })    
  end
  
  def comment_notification(comment, proposal)
    recipients  proposal.email
    from        "#{proposal.ignite.name} \<no-reply@#{proposal.ignite.domain}\>"
    subject     "A comment was left on your proposal"
    body        ({ :proposal => proposal, :comment => comment })
  end
    
end
