require 'rails_helper'

RSpec.describe Book, type: :model do
  context "creation of book" do
    it "should not create a valid book" do
      book = Book.new
      expect(book.save).to eq(false)
    end

    it "creates a valid book" do
        book = Book.new(title: "A book", author: "Me", publication_date: "2023-11-17T22:35:00+00:00")
        book.save

        book.reload

        expect(book.status).to eq(:available.to_s)
        expect(book.id).to_not be nil
    end

    it "does not create a valid book in the future" do
        book = Book.new(title: "A book", author: "Me", publication_date: "2025-11-17T22:35:00+00:00")
        expect(book.save).to eq(false)
        expect(book.errors).to_not be nil

    end
  end

  describe "update book" do
    context "status" do
      it "updates to valid status" do
        book = Book.new(title: "A book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00")
        book.save

        book.reload

        expect(book.status).to eq(:available.to_s)

        book.update(status: :reserved)

        expect(book.status).to eq(:reserved.to_s)
      end

      it "does not update to invalid status" do
        book = Book.new(title: "A book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00")
        book.save

        book.reload
        expect { book.update(status: :sold_out) }.to raise_error
      end
    end
  end
end
