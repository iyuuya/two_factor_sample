# frozen_string_literal: true
class TwoFactorMailer < ApplicationMailer
  def two_factor(user)
    @user = user
    mail subject: "TwoFactor", to: user.email
  end
end
