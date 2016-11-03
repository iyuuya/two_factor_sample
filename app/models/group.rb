# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  two_factor_auth :boolean          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Group < ApplicationRecord
  validates :name, presence: true
  validates :two_factor_auth, inclusion: { in: [true, false] }

  has_many :users
end
