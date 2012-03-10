module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :scope => 'read_stream',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
end