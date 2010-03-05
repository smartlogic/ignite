# Monkeypatch should_change and should_not_change.
# As of v2.10.3, this monkeypatch is required
# Remove this once it is merged in: http://github.com/thoughtbot/shoulda/issues/#issue/74
module Shoulda
  module Macros
    def should_change(description, options = {}, &block)
      by, from, to = get_options!([options], :by, :from, :to)
      stmt = "change #{description}"
      stmt << " from #{from.inspect}" if from
      stmt << " to #{to.inspect}" if to
      stmt << " by #{by.inspect}" if by
 
      if block_given?
        code = block
      else
        warn "[DEPRECATION] should_change(expression, options) is deprecated. " <<
             "Use should_change(description, options) { code } instead."
        code = lambda { eval(description) }
      end
      var_name = description_to_variable(description)
      before = lambda { self.instance_variable_set(var_name, code.bind(self).call) }
      should stmt, :before => before do
        old_value = self.instance_variable_get(var_name)
        new_value = code.bind(self).call
        assert_operator from, :===, old_value, "#{description} did not originally match #{from.inspect}" if from
        assert_not_equal old_value, new_value, "#{description} did not change" unless by == 0
        assert_operator to, :===, new_value, "#{description} was not changed to match #{to.inspect}" if to
        assert_equal old_value + by, new_value if by
      end
    end

    def should_not_change(description, &block)
      if block_given?
        code = block
      else
        warn "[DEPRECATION] should_not_change(expression) is deprecated. " <<
             "Use should_not_change(description) { code } instead."
        code = lambda { eval(description) }
      end
      var_name = description_to_variable(description) 
      before = lambda { self.instance_variable_set(var_name, code.bind(self).call) }
      should "not change #{description}", :before => before do
        new_value = code.bind(self).call
        assert_equal self.instance_variable_get(var_name), new_value, "#{description} changed"
      end
    end

    def description_to_variable(description)
      "@#{description.gsub(/[^a-z0-9\-_\+]+/i, "_").downcase}_before_should_change"
    end
  end
end

module Shoulda
  module IgniteMacros
    def should_flash(stream, msg=nil)
      should "flash a #{stream} message" do
        assert_flash(stream, msg)
      end
    end

    def should_not_flash(stream)
      should "not flash a #{stream} message" do
        assert_no_flash(stream)
      end
    end
    
    def should_not_render_new_proposal_link
      should "not render a link to submit a proposal" do
        assert_select "a", :text => "Submit a Proposal", :count => 0
      end
    end
    
    def should_render_new_proposal_link
      should "render a link to submit a proposal" do
        assert_select "a", :text => "Submit a Proposal", :count => 1
      end
    end
  end
end
