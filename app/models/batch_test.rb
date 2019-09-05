# == Schema Information
#
# Table name: batch_tests
#
#  id         :integer          not null, primary key
#  batch_id   :integer
#  test_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class BatchTest < ApplicationRecord
  belongs_to :batch
  belongs_to :test
end
