# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string(255)      default(""), not null
#  encrypted_password        :string(255)      default(""), not null
#  reset_password_token      :string(255)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  confirmation_token        :string(255)
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  unconfirmed_email         :string(255)
#  group_id                  :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  encrypted_otp_secret      :string(255)
#  encrypted_otp_secret_iv   :string(255)
#  encrypted_otp_secret_salt :string(255)
#  consumed_timestep         :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_group_id              (group_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  belongs_to :group

  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => Settings.devise.two_factor.encrypt_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation do
    if otp_required_for_login
      self.otp_secret ||= User.generate_otp_secret(32)
    end
  end

  def otp_required_for_login
    group.two_factor_auth
  end

  def self.otp_allowed_drift
    Settings.devise.two_factor.allowed_drift.minutes.to_i
  end
end
