class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :publication_date, presence: true, comparison: { less_than: Time.zone.now }
  validates :rating, inclusion: { in: 0..5 }

  enum :status, { available: "available", checked_out: "checked_out", reserved: "reserved" }, validates: true, default: :available
end
