require File.dirname(__FILE__) + '/../test_helper'

class OrganizerTest < ActiveSupport::TestCase
  context 'a saved organizer' do
    setup do
      @organizer = Factory(:organizer)
    end
    subject { @organizer }
    should_validate_presence_of :ignite_id, :name
  end
end
