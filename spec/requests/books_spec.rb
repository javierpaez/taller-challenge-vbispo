require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /books" do
    it "returns ok" do
      get books_path
      expect(response).to have_http_status(:ok)
    end

    it "returns the books that we have" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      get books_path
      expect(response).to have_http_status(:ok)

      parsed_body = JSON.parse(response.body)

      expect(parsed_body.count).to eq(1)
    end

    it "returns the books for the highest rating to the lowest rating" do
      post books_path, params: { book: { title: "A book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00", rating: 1 } }
      post books_path, params: { book: { title: "Totally different book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00", rating: 5 } }

      get books_path
      expect(response).to have_http_status(:ok)

      parsed_body = JSON.parse(response.body)

      first_book = parsed_body.first
      last_book = parsed_body.last

      expect(first_book["title"]).to eq("Totally different book")
      expect(last_book["title"]).to eq("A book")

      expect(parsed_body.count).to eq(2)
    end

    it "returns the books for the highest rating to the lowest rating then from the soonest date" do
      post books_path, params: { book: { title: "A book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00", rating: 1 } }
      post books_path, params: { book: { title: "Totally different book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00", rating: 5 } }
      post books_path, params: { book: { title: "Other different book", author: "Me", publication_date: "2023-10-18T22:35:00+00:00", rating: 5 } }

      get books_path
      expect(response).to have_http_status(:ok)

      parsed_body = JSON.parse(response.body)

      first_book = parsed_body.first
      second_book = parsed_body.second
      last_book = parsed_body.last

      expect(first_book["title"]).to eq("Totally different book")
      expect(second_book["title"]).to eq("Other different book")
      expect(last_book["title"]).to eq("A book")

      expect(parsed_body.count).to eq(3)
    end
  end

  describe "POST /books" do
    it "returns created" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      expect(response).to have_http_status(:created)
    end

    it "shows the id of the book" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      expect(response.parsed_body["id"]).not_to be nil

    end
  end

  describe "PUT /books/:id" do
    it "updates the book" do
      # Arrange
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      put book_path(id), params: { book: { title: "My New Book" } }

      expect(response).to have_http_status(:successful)
    end

    it "updates the status of the book" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      put book_path(id), params: { book: { status: :reserved } }

      expect(response).to have_http_status(:successful)
    end

    it "updates the rating of the book" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      put book_path(id), params: { book: { rating: 3 } }

      expect(response).to have_http_status(:successful)
    end

    it "handles not found" do
      id = 0
      put book_path(id), params: { book: { title: "My New Book" } }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /books/:id" do
    it "deletes the book" do
      # Arrange
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      delete book_path(id)

      expect(response).to have_http_status(:successful)
    end

    it "handles not found" do
      id = 0
      delete book_path(id)

      expect(response).to have_http_status(:not_found)
    end

    it "should not show when book is deleted" do
      # Arrange
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      delete book_path(id)

      expect(response).to have_http_status(:successful)

      get book_path(id)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /books/:id" do
    it "shows the book" do
      # Arrange
      post books_path, params: { book: { title: "My Book", author: "Me", publication_date: "2023-11-18T22:35:00+00:00" } }

      id = response.parsed_body["id"]

      get book_path(id)

      expect(response).to have_http_status(:successful)
    end
  end
end
