module IgniteAssertions
  def assert_flash(stream, msg=nil)
    if msg
      assert_equal msg, flash[stream]
    else
      assert_not_nil flash[stream]
    end
  end

  def assert_no_flash(stream)
    assert_nil flash[stream]
  end
end