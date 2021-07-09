require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[first@web.com SECOND@web.COM THIR-RD@web.org]

    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@site,com user_at_site.org user.name@example. user@web_site.com]

    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExaMPLE.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
