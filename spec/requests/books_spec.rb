require 'rails_helper'

RSpec.describe "Books", type: :request do
  after do
    $books = []
  end
  describe "GET /books" do
    it "returns ok" do
      get books_path
      expect(response).to have_http_status(:ok)
    end

    it "returns the books that we have" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

      get books_path
      expect(response).to have_http_status(:ok)

      parsed_body = JSON.parse(response.body)

      expect(parsed_body.count).to eq(1)
    end
  end

  describe "POST /books" do
    it "returns created" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

      expect(response).to have_http_status(:created)
    end

    it "shows the id of the book" do
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

      expect(response.parsed_body["id"]).not_to be nil

    end
  end

  describe "PUT /books/:id" do
    it "updates the book" do
      # Arrange
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

      id = response.parsed_body["id"]

      put book_path(id), params: { book: { title: "My New Book" } }

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
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

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
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

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
      post books_path, params: { book: { title: "My Book", author: "Me", publication_year: 2024 } }

      id = response.parsed_body["id"]

      get book_path(id)

      expect(response).to have_http_status(:successful)
    end
  end
end
