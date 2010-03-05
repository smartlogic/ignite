require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < ActiveSupport::TestCase

  def test_should_create_admin
    assert_difference 'Admin.count' do
      admin = create_admin
      assert !admin.new_record?, "#{admin.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'Admin.count' do
      u = create_admin(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Admin.count' do
      u = create_admin(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Admin.count' do
      u = create_admin(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Admin.count' do
      u = create_admin(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    ggentzke.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal ggentzke, Admin.authenticate('ggentzke', 'new password')
  end

  def test_should_not_rehash_password
    ggentzke.update_attributes(:login => 'ggentzke2')
    assert_equal ggentzke, Admin.authenticate('ggentzke2', 'ggentzke')
  end

  def test_should_authenticate_admin
    assert_equal ggentzke, Admin.authenticate('ggentzke', 'ggentzke')
  end

  def test_should_set_remember_token
    ggentzke.remember_me
    assert_not_nil ggentzke.remember_token
    assert_not_nil ggentzke.remember_token_expires_at
  end

  def test_should_unset_remember_token
    ggentzke.remember_me
    assert_not_nil ggentzke.remember_token
    ggentzke.forget_me
    assert_nil ggentzke.remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    ggentzke.remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil ggentzke.remember_token
    assert_not_nil ggentzke.remember_token_expires_at
    assert ggentzke.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    ggentzke.remember_me_until time
    assert_not_nil ggentzke.remember_token
    assert_not_nil ggentzke.remember_token_expires_at
    assert_equal ggentzke.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    ggentzke.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil ggentzke.remember_token
    assert_not_nil ggentzke.remember_token_expires_at
    assert ggentzke.remember_token_expires_at.between?(before, after)
  end

protected
  def create_admin(options = {})
    record = Admin.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.save
    record
  end
end
