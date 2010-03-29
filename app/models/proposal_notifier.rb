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
  
end
