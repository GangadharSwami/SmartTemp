class StudentNotification < ApplicationRecord
  belongs_to :student
  belongs_to :notification
end
